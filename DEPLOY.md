# Deployment

## Deploy a release

```bash
mix edeliver build release
mix edeliver deploy release to production --version=x.x.x
mix edeliver restart production
mix edeliver migrate production
```

## Deploy an upgrade

```bash
mix upgrade
```

or

```bash
# Don't clean mix & npm deps
mix hotfix
```
