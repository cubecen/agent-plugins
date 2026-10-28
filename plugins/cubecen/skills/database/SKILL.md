---
name: database
description: Use when an app needs a database or Postgres on Cubecen, the user asks to add, connect, migrate or seed a database, DATABASE_URL is missing, or Cubecen answers DATABASE_NOT_READY or DATABASE_REFERENCED.
---

# A Postgres database on Cubecen

Cubecen's databases are managed Postgres 17 (Frankfurt), one or more per
project. Cubes reach them through env references; nobody handles the
password.

## 1. The plan

`get_organization`: Free has no databases; Launch and Scale do (their
count is in the plan's limits). Without one, give the plan page link.

## 2. The database

`list_databases`; else `create_database` with a `name`, in the cube's
project. The answer names its slug: use that slug below.

## 3. Wire it

`set_env` on the cube: `DATABASE_URL = ${{ <slug>.DATABASE_URL }}` (pooled,
for the app); migration tools, `LISTEN` or session state use
`${{ <slug>.DATABASE_URL_UNPOOLED }}`. References work in variables only,
never in a key the browser reads; previews never get them.

## 4. Migrations

Find the app's migration tool in the repository (`prisma/`,
`drizzle.config.*`, `alembic.ini`, `db/migrate/`, `migrations/`), then read
`references/migrations.md` for it. Prefer running them
when the cube starts (in its start command or start script), so every
deploy migrates. A one-off run from this machine only with the user's yes.

## 5. Deploy

`get_database` until it is `ready` (about a minute); a deploy before that
answers `DATABASE_NOT_READY`: wait and call again. Then `redeploy` the
cube (`deploy` when the build reads the database), and `wait_for_release`.

## Rules

- Never print a password or a connection string; never paste them in a
  command the user sees. `get_database_connection` answers both: use it
  only for a run the user agreed to.
- `reset_database_password` cuts every cube off until it redeploys;
  `delete_database` deletes the data: confirm both with the user.
- `DATABASE_REFERENCED`: cubes still refer to the database; unset their
  references before deleting it.
