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

Copy `nginx.config` into nginx directory and activate it.
