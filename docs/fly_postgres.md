# Setting up Fly.io Postgres

1. Setup main Fly.io app first
2. Run `nix run .#fly-setup-postgres` to create a cluster and attach it to the app
3. Save `DATABASE_URL`'s content to 1Password
4. Setup auto-down scale following https://fly.io/docs/postgres/managing/scale-to-zero/
