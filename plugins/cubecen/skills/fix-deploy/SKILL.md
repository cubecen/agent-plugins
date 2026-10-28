---
name: fix-deploy
description: Use when a Cubecen build or deployment failed (BUILD_FAILED, DEPLOY_FAILED), the user asks why their Cubecen deploy broke, or Cubecen reports BUILD_NOT_DETECTED, START_COMMAND_NOT_FOUND, APP_NOT_LISTENING, APP_CRASHED, APP_OUT_OF_MEMORY, QUOTA_EXCEEDED, or PLAN_LIMIT_REACHED for build minutes.
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
  `output_directory`): `update_application`, then `deploy` (they apply
  from the next build). `size` applies at once.
- **Environment**: `set_env` (`secret: true` for secrets; `build: true`
  for a key the build reads), then `deploy`: it reuses the failed
  release's build when only runtime variables changed. Not `redeploy`: it
  brings back the build that is serving, without the new commit. A value
  you do not have comes from the user; never invent one, and ask before
  copying it from a local `.env`.
- **Not the app**: say so; no code change. `QUOTA_EXCEEDED`: deploy again
  later. The plan's build minutes used up (`PLAN_LIMIT_REACHED`, or
  `Over its limits: build_minutes`): they come back on `get_organization`'s
  `usage.to`; `redeploy` (no build) works meanwhile; or a bigger plan, which
  an owner asks for (`team-and-account` skill).

The codes and their usual fixes: `references/codes.md`.

Then wait for the new release, and repeat if it fails differently.

## 4. Report

Your last message is the report, in this order:

1. **Cause**: one or two sentences, quoting the log line that shows it.
2. **Change**: what you changed (file and line, setting or variable), or
   the change you propose when you made none.
3. **Next**: the commit and push you ask for, the release to wait for,
   or what the user must do.

## Rules

- Never commit, push or print a secret without the user's yes.
