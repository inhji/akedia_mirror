# Akedia

> „Der Dämon der Trägheit, der auch Mittagsdämon genannt wird, ist belastender als alle anderen Dämonen.“


## Development with ngrok

```bash
TUNNEL=true phx
```

## Deployment

deploy a release:

```bash
mix edeliver build release
mix edeliver deploy release to production --version=x.x.x
mix edeliver restart production
mix edeliver migrate production
```

deploy an upgrade:

```bash
mix deploy
```

## Installation

### Server

```bash
# Basis Pakete
apt install nginx build-essential imagemagick software-properties-common postgresql postgresql-contrib

# Certbot, siehe
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt install certbot python-certbot-nginx

# Elixir, siehe: https://elixir-lang.org/install.html#unix-and-unix-like
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
apt update
apt install esl-erlang elixir

# Node 11, siehe https://github.com/nodesource/distributions#deb
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Postgres

```bash
# Als postgres Benutzer einloggen
sudo -i -u postgres
# Akedia Benutzer anlegen
createuser --interactive
# Akedia Datenbank anlegen
createdb akedia_prod
# Rechte setzen
psql
```

```sql
-- Add pg_trgm Extension
CREATE extension if not exists pg_trgm;
-- Adjust privileges
grant all privileges on database akedia_prod to akedia;
```

### Nginx

Copy `nginx.config` into nginx directory and activate it.
