# Akedia

## Database Setup

```sql
CREATE extension if not exists pg_trgm;
```

## Development with ngrok

```bash
HOST=http://xxx.ngrok.io mix phx.server
```

## Deployment

* Dependencies on the target system:
  * `build_essential`
  * `imagemagick`

Nginx needs to be configured to alias requests to `/upload` to the uploads dir:

```nginx
location /uploads {
    alias <APP_DIR>/release/akedia/uploads;
}
```


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

## Sever Setup

install nginx, certbot, build-essential, imagemagick, node (nodesource)
