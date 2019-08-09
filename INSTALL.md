# Installation

## Server

### Raspberry Pi (with Raspbian 10 Buster)

Install dependencies

```bash
# Base packages
apt install nginx build-essential imagemagick software-properties-common postgresql postgresql-contrib

# Certbot
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt install certbot python-certbot-nginx

# Node 11, see https://github.com/nodesource/distributions#deb
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Add Akedia User and App Dir

```bash
sudo useradd -r -s /bin/false -m -d /var/lib/akedia -U akedia
sudo mkdir /opt/akedia
sudo chown -R akedia:akedia /opt/akedia
```

Install asdf-vm

```bash
# Clone asdf
sudo -Hu akedia $SHELL
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"

# Add to bashrc
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
source ~/.bashrc

# Add plugins
asdf plugin-add erlang
asdf plugin-add elixir
```

Install Erlang

```bash
sudo -Hu akedia $SHELL
asdf list-all erlang
# > This will take several hours
asdf install erlang <version>
```

Install Elixir

```bash
sudo -Hu akedia $SHELL
asdf list-all elixir
asdf install elixir <version>
```

Initial Directory Structure

```bash
sudo -Hu akedia $SHELL
mkdir -p /opt/akedia/{config,build,release,tzdata/release_ets}
# Add tzdata database
cd /opt/akedia/tzdata/release_ets
wget https://github.com/lau/tzdata/blob/master/priv/release_ets/2019a.v2.ets
```



### Ubuntu 18.04 LTS

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

## Postgres

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

## Nginx

Copy `nginx.config` into nginx directory and activate it.
