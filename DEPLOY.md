# Deployment

## Deploy a release

Deploying a new release shouldn't be needed very often.

```bash
mix edeliver build release
mix edeliver deploy release to production --version=x.x.x
mix edeliver restart production
mix edeliver migrate production
```

## Deploy an upgrade

> Right now pgrading does not work reliably due to a possible bug in edeliver. Should rather do a new release each time.

There are two tasks to deploy an upgrade:

### Upgrade

Upgrading cleans all dependencies from the previous build and therefore takes longer than `mix hotfix`.

```bash
mix upgrade
```

### Hotfix

Hotfix is the same as upgrade but without cleaning the dependencies, thus making it faster but also more prone to weird dependency-errors.

*Restarting the server is recommended to make sure the newest css styles are used.*

```bash
# Don't clean mix & npm deps
mix hotfix
mix restart
```
