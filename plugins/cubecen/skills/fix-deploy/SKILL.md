---
name: fix-deploy
description: Use when a Cubecen build or deployment failed (BUILD_FAILED, DEPLOY_FAILED), the user asks why their Cubecen deploy broke, or Cubecen reports BUILD_NOT_DETECTED, START_COMMAND_NOT_FOUND, APP_NOT_LISTENING, APP_CRASHED, APP_OUT_OF_MEMORY, QUOTA_EXCEEDED or PLAN_LIMIT_REACHED.
---

# Fix a failed Cubecen deploy

A failed release leaves the previous one serving: find the cause, do not
guess.

## 1. Read the diagnosis

- The release: the one `wait_for_release` just answered; else
  `list_applications` with `repository: "owner/name"` names a failed last
  release, or `list_releases`; then `get_release`.
- A failed release's answer is its diagnosis, line by line: `cause:`,
  `fix:`, `seen in the log:` (known failures quoted from the log), the
  failing log lines, `next:`. Read all of it first.
- More log when needed: `get_logs` with the `source` and `id` the answer
  names and `errors: true`; the app's own output: `source: runtime`,
  `errors: true`, `since: 1h`. Memory or restarts: `get_metrics`.

## 2. Find it in the code

Open the file and line the log points to.

## 3. Fix it where it is

- **Code** (a compile error, a bad listen call, a missing start script):
  edit it and show the change. Ask before you commit and push; after the
  push, `wait_for_release` with `commit`.
- **Settings** (`app_root`, `port`, `start_command`, `build_command`,
  `output_directory`, `size`): `update_application`, then `deploy`
  (settings apply from the next build).
- **Environment**: `set_env` (`secret: true` for secrets), then
  `redeploy`. A key the build reads needs `build: true` and `deploy`: a
  redeploy reuses the old build. A value you do not have comes from the
  user; never invent one, and ask before copying it from a local `.env`.
- **Not the app** (a quota or the plan's limit, see Codes): say so; no
  code change.

Then wait for the new release, and repeat if it fails differently.

## 4. Report

Your last message is the report, in this order:

1. **Cause**: one or two sentences, quoting the log line that shows it.
2. **Change**: what you changed (file and line, setting or variable), or
   the change you propose when you made none.
3. **Next**: the commit and push you ask for, the release to wait for,
   or what the user must do.

## Codes

| Code | Usual fix |
|---|---|
| `BUILD_NOT_DETECTED` | `app_root` to the app's folder (`get_repository_folders`), or a Dockerfile |
| `START_COMMAND_NOT_FOUND` | a `start` script, `start_command`, or `output_directory` for a static site |
| `START_COMMAND_NEEDS_SHELL` | clear `start_command`, or an image with `/bin/sh` |
| `WORKFLOW_EXECUTION_FAILED` | the failing step's error in the log: code, install or a build-time variable |
| `APP_NOT_LISTENING` | listen on `0.0.0.0` and `PORT`, or set `port` |
| `APP_CRASHED` | the log's error: often a missing variable or an unreachable database |
| `APP_OUT_OF_MEMORY` | the code that fills memory at start or per request; or a bigger size within the plan |
| `QUOTA_EXCEEDED` | nothing in the app: deploy again later |
| `PLAN_LIMIT_REACHED` | build minutes come back on `get_organization`'s `usage.to`; `redeploy` (no build) works meanwhile; or a bigger plan |
| `ENV_REFERENCE_BROKEN` | `get_env`, then point the named variable at an existing cube or database, or unset it |

## Rules

- Never commit, push or print a secret without the user's yes.
