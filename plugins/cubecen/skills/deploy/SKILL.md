---
name: deploy
description: Deploy the app in the current repository to Cubecen and give back its live URL. Use when the user asks to deploy, ship, host or publish their app on Cubecen, put it online, or update a Cubecen deployment after changes.
---

# Deploy to Cubecen

Cubecen builds from GitHub, not from this machine: it deploys what is pushed.
The Cubecen MCP tools take slugs and find the organization, project and
GitHub connection themselves; never ask the user for an ID.

## 1. Read the repository

- `git remote get-url origin` gives `owner/name`. Cubecen deploys GitHub
  repositories only: with no GitHub remote, offer to create one
  (`gh repo create`) before going on.
- The app's folder: when the app is not at the repository root (a monorepo,
  or the user is in a subfolder), its path from the root is `app_root`
  (`git rev-parse --show-prefix`, or `get_repository_folders`).
- The branch: `git branch --show-current`. When it is not the repository's
  default branch, ask whether the cube should track it (`deploy_branch`) or
  deploy it once (`revision`).

## 2. Make sure GitHub has the code

`git status --porcelain` and `git log @{u}..` show uncommitted and unpushed
work. When there is some the user wants live, show it and ask before you
commit or push: never push without asking.

## 3. Check the app is ready

Follow the `prepare-app` skill: the port, the start command, the framework's
needs and the environment variables. Fix what would fail now, before a build
that fails in five minutes.

## 4. Create or deploy

`list_applications` and look for a cube with this repository and `app_root`.

- **There is one:** a push to its tracked branch already starts a release
  (push to deploy). After pushing, `list_releases` for that cube: wait on the
  release of the pushed commit instead of deploying again. Otherwise `deploy`
  it (with `revision` for another branch).
- **There is none:** `create_application` with `repository: "owner/name"`,
  plus `app_root`, `deploy_branch` and the settings `prepare-app` found
  (`port`, `start_command`, `build_command`, `output_directory`). The name and
  project default sensibly; pass them only when the user chose them.
  When the app needs environment variables or a database, create with
  `deploy: false`, do step 5, then `deploy`.
- **`GITHUB_NOT_CONNECTED` or `REPOSITORY_NOT_ACCESSIBLE`:** the repository is
  private. `connect_github` gives a link: give it to the user, wait until
  they say it is done, then call `create_application` again. Public
  repositories need no connection.

## 5. Environment and database

- Variables: find what the app reads (`.env.example`, the README, the code's
  `process.env` / `os.Getenv` / `ENV[...]`). `set_env` them on the cube, with
  `secret: true` for passwords, tokens and keys.
  Values in a local `.env` may be secrets: ask before you copy them, and do
  not print them. Keys with a public prefix (`VITE_`, `NEXT_PUBLIC_`,
  `PUBLIC_`, `REACT_APP_`, `NUXT_PUBLIC_`, `EXPO_PUBLIC_`, `GATSBY_`) end up
  in the browser bundle: warn when one holds a secret, and mark them `build`
  so a change rebuilds.
- Postgres: when the app needs one (`DATABASE_URL`, `pg`, Prisma, Drizzle,
  SQLAlchemy, ActiveRecord, …), offer `create_database`, then
  `set_env` `DATABASE_URL = ${{ <database-slug>.DATABASE_URL }}`. A
  `DATABASE_NOT_READY` refusal means wait a few seconds and retry. Never
  handle the database password; run the app's migrations from its start
  command or a release step, as the app already does.
- Env changes apply with the next `deploy` or `redeploy`.

## 6. Wait and report

`wait_for_release` with the release the previous answer named; call it again
while it is not terminal. When it is live, give the URL. When it failed,
follow the `fix-deploy` skill.

## Rules

- A refusal reads `CODE: message`, maybe with `field:` and `next:` lines: do
  what `next` says.
- Tools marked destructive (`delete_*`, `remove_*`, `rollback`,
  `restore_env`, `set_previews`, `reset_database_password`) change what is
  live or discard data: confirm with the user first.
- When the Cubecen tools are missing, the MCP server is not connected: ask
  the user to sign in (Claude Code: `/mcp`; Codex: `/plugins`).
