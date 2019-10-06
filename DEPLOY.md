# Deployment

## Deploy a release

```bash
mix build
mix deploy --version=x.x.x
mix restart
mix migrate
```

> Hot upgrades are busted right now, just deploy a new release