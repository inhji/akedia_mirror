# Deployment

The deploy pipeline relies on `edeliver` and `distillery`. Additionally, there are custom mix tasks for building and deploying. For more info about them, see `MixBuild` and `MixDeploy`

```bash
mix build
mix deploy
mix restart
mix migrate
```