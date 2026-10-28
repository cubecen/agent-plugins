---
name: deploy
description: Use when the user asks to deploy, ship, host, publish or put an app online on Cubecen, asks whether a push deployed, or wants to update a Cubecen deployment after changes, set up a cube for a repository, or deploy several apps of one repository (a monorepo, a web and an API).
---

# Deploy to Cubecen

Cubecen builds from GitHub, not from this machine: what is pushed is what
deploys.

## 1. The repository

- `git remote get-url origin` gives `owner/name` (GitHub only). With no
  GitHub remote, Cubecen cannot build it yet: ask whether to create a
  private GitHub repository and push (`gh repo create <name> --private
  --source=. --push`); public only if the user says so. A private
  repository needs `connect_github` once.
- The app's folder from the repository root is `app_root`
  (`git rev-parse --show-prefix`). Several apps in the repository:
  read `references/multi-service.md` first.
- The branch: `git branch --show-current`. Not the repository's default
  branch: ask whether the cube tracks it (`deploy_branch`) or deploys it
  once (`revision`).
- `git` fails? Read `.git/config` (origin's `url`), `.git/HEAD` (the
  branch) and `.git/refs/heads/<branch>` or `.git/packed-refs` (the commit).

## 2. What GitHub has

`git status --porcelain` and `git log @{u}..` show work that is not pushed.
To make it live, show it and ask before you commit and push.

## 3. Create or deploy

1. `list_applications` with `repository: "owner/name"` (and `app_root`)
   finds the cube.
2. **A cube exists.** A push to the branch it tracks starts its release:
   `wait_for_release` with `commit` (the pushed SHA). A cube made from a
   public repository's link never deploys on push: call `deploy`, and
   tell the user once how pushes could deploy
   (`references/github-connection.md`).
3. **No cube: a first deploy.** **REQUIRED SUB-SKILL** when the app's code
   is here: load `prepare-app` before `create_application`; its checks
   catch what fails here though it runs locally (localhost, a fixed port, a
   root-only image). Then `create_application` with
   `repository: "owner/name"` and `app_root`, plus what they found (`port`,
   `start_command`, `build_command`, `output_directory`). It deploys and
   names the release. When the app needs variables or a
   database before it can start, pass `deploy: false`, do section 4, then
   `deploy`.
4. **`REPOSITORY_NOT_CONNECTED`** (no GitHub connection covers it) or
   **`REPOSITORY_NOT_ACCESSIBLE`**: read `references/github-connection.md`
   first. Never pick the public link alone.

## 4. Environment and database

- Variables the app reads (`.env.example`, the README, `process.env`,
  `os.environ`, `os.Getenv`): `set_env`, with `secret: true` for passwords,
  tokens and keys. A local `.env` holds secrets: ask before copying from
  it, and never print a value.
- Keys the build reads (`VITE_`, `NEXT_PUBLIC_`, `REACT_APP_`, … or any
  the build step reads):
  `build: true`. Public prefixes end up in the browser bundle: never a
  secret there.
- A database: follow the `database` skill.
- Env changes apply with the next `deploy` (it reuses the build when only
  runtime variables changed).

## 5. Wait and report

`wait_for_release` with the release (or `commit`), again while it is not
terminal. Live: give the URL. Failed: its answer carries the diagnosis;
follow the `fix-deploy` skill.

## Rules

- Never commit, push or create a GitHub repository without the user's yes.
- Destructive tools (`delete_*`, `remove_*`, `rollback`, `cancel_release`,
  `restore_env`, `set_previews`, `reset_database_password`): confirm first.
- No Cubecen tools listed: the MCP server is not signed in; ask the user to
  sign in (Claude Code: `/mcp`; Codex: `/plugins`).
