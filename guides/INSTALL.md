# Installation

## Dependencies

### Base Packages

```bash
apt install nginx build-essential imagemagick software-properties-common postgresql postgresql-contrib
```

### Erlang & Elixir

See: [https://elixir-lang.org/install.html](https://elixir-lang.org/install.html)

```bash
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install elixir
```

### Certbot

```bash
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt install certbot python-certbot-nginx
```

### Node.js

See: [https://github.com/nodesource/distributions#deb](https://github.com/nodesource/distributions#deb)

```bash
# Node 11, see 
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## User

### Add user

```bash
sudo useradd -r -s /bin/false -m -d /var/lib/akedia -U akedia
sudo mkdir /opt/akedia
sudo chown -R akedia:akedia /opt/akedia
```

### Setup directory structure

```bash
sudo -Hu akedia $SHELL
mkdir -p /opt/akedia/{config,build,release,tzdata/release_ets}
cd /opt/akedia/build
git init
# Add tzdata database
cd /opt/akedia/tzdata/release_ets
wget https://github.com/lau/tzdata/blob/master/priv/release_ets/2019a.v2.ets
```

## Postgres

Create akedia user & database

```bash
# Login as postgres user
sudo -i -u postgres
# Add akedia user
createuser --interactive
# Create akedia database
createdb akedia_prod
```

Setup akedia database

```sql
psql
-- Set password for akedia user
\password akedia
-- Connect to akedia_prod
\c akedia_prod
-- Add pg_trgm Extension
CREATE extension if not exists pg_trgm;
-- Adjust privileges
grant all privileges on database akedia_prod to akedia;
```

## Nginx

Create secure diffie-hellman parameters

```bash
openssl dhparam -out /etc/nginx/dhparams.pem 4096
```

Create new virtual host at `/etc/nginx/sites-available/akedia.conf`:

```nginx
map $sent_http_content_type $expires {
  default                    off;
  text/html                  epoch;
  text/css                   max;
  application/javascript     7d;
  ~image/                    max;
}

map $http_upgrade $connection_upgrade {
  default upgrade;
  '' close;
}

# ---------- DEV TUNNEL ----------

server {
  listen 80;
  server_name tunnel.inhji.de;
  return 301 https://$server_name$request_uri;
}

server {
  listen 443 http2 ssl;
  server_name tunnel.inhji.de;

  ssl_certificate /etc/letsencrypt/live/tunnel.inhji.de/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/tunnel.inhji.de/privkey.pem;

  location / {
    proxy_pass http://localhost:4001;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_redirect off;

    error_page 502 /50x.html;
    location = /50x.html {
      root /usr/share/nginx/html;
    }
  }
}

# ---------- MAIN SITE ----------

server {
  listen 80;
  server_name inhji.de www.inhji.de;
  return 301 https://$server_name$request_uri;
}

server {
  listen 443 http2 ssl default_server;
  listen [::]:443 http2 ssl default_server;

  ssl_certificate /etc/letsencrypt/live/inhji.de/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/inhji.de/privkey.pem;

  ssl_protocols TLSv1.2 TLSv1.3;# Requires nginx >= 1.13.0 else use TLSv1.2
  ssl_prefer_server_ciphers on;
  ssl_dhparam /etc/nginx/dhparams.pem;
  ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
  ssl_ecdh_curve secp384r1; # Requires nginx >= 1.1.0
  ssl_session_timeout  10m;
  ssl_session_cache shared:SSL:10m;
  ssl_session_tickets off; # Requires nginx >= 1.5.9

  add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
  add_header Referrer-Policy no-referrer-when-downgrade;

  add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; object-src 'none'; style-src 'self'; img-src 'self' data: cloud.inhji.de; media-src 'self'; frame-src 'none'; font-src 'self'; connect-src 'self'";
  add_header X-Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; object-src 'none'; style-src 'self'; img-src 'self' data: cloud.inhji.de; media-src 'self'; frame-src 'none'; font-src 'self'; connect-src 'self'";
  add_header X-WebKit-CSP "default-src 'self'; script-src 'self' 'unsafe-inline'; object-src 'none'; style-src 'self'; img-src 'self' data: cloud.inhji.de; media-src 'self'; frame-src 'none'; font-src 'self'; connect-src 'self'";
  server_name inhji.de;

  client_max_body_size 10M;
  expires $expires;

  rewrite ^/.well-known/(host-meta|webfinger).* https://fed.brid.gy$request_uri redirect;

  # Nginx needs to be configured to alias requests to `/upload` to the uploads dir
  location /uploads {
    alias /opt/akedia/release/akedia/uploads;
  }

  location / {
    proxy_pass http://localhost:4000;
    proxy_http_version 1.1;
    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header X-forwarded-host $host;
    proxy_set_header HOST $host;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
  }

}

```

## Systemd

Create a new systemd under `/etc/systemd/system/akedia.service`:

```
[Unit]
Description=Akedia

[Service]
Type=forking
User=akedia
Group=akedia
Restart=on-failure

WorkingDirectory=/opt/akedia/release/akedia/bin
ExecStart=/opt/akedia/release/akedia/bin/akedia start
ExecStop=/opt/akedia/release/akedia/bin/akedia start

[Install]
WantedBy=multi-user.target
```