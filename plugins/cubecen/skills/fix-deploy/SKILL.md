---
name: fix-deploy
description: Find out why a Cubecen build or deploy failed, or why a live Cubecen app misbehaves, from its logs, and fix it in the code or the cube's settings. Use when a Cubecen release failed, the user asks why their Cubecen deploy broke, or their Cubecen app crashes, errors or is slow.
---

# Fix a failed Cubecen deploy

A failed release leaves the previous one serving: there is time to find the
cause instead of guessing.

## 1. Find the failure

- The release: the one `wait_for_release` just reported, or the newest from
  `list_releases`. `get_release` gives its stage, error code and message,
  and names the `get_logs` call for the failed stage.
- Read that log: `get_logs` with `source: "build"` or `"deployment"` and the
  `id` it named. For a live app that misbehaves, `source: "runtime"`, and
  `get_metrics` for memory and CPU.
- Read the app's code where the log points. Explain the cause in one or two
  sentences before changing anything.

## 2. Codes

| Code | Cause | Fix |
|---|---|---|
| `BUILD_NOT_DETECTED` | No `Dockerfile`, and Railpack found no known app in `app_root` | Fix `app_root` (`get_repository_folders`), or add a `Dockerfile` |
| `START_COMMAND_NOT_FOUND` | Nothing to run: no `start` script and no start command | Add a `start` script, set `start_command`, or for a static site set `output_directory` |
| `START_COMMAND_NEEDS_SHELL` | `start_command` set, but the Dockerfile image has no `/bin/sh` | Clear `start_command` (the image's own command runs) or use an image with a shell |
| `WORKFLOW_EXECUTION_FAILED` | A step failed: compile error, failed install, missing build-time variable | The build log names the step; fix the code, or set the variable with `build: true` |
| `APP_NOT_LISTENING` | The app ran but did not accept connections on its port | Listen on `0.0.0.0:$PORT`, or set `port` to the app's port |
| `APP_CRASHED` | The app exited; the message has the exit code | Read the deployment log: often a missing variable, a failed database connection or a wrong start command. SvelteKit with exit 1: use `@sveltejs/adapter-node`. Official `nginx` image: use `nginxinc/nginx-unprivileged` |
| `APP_OUT_OF_MEMORY` | Over the cube's memory | Fix a leak or a large build-time step in the start command, or a bigger `size` within the plan |
| `QUOTA_EXCEEDED` | The platform had no room right now; not the app's fault | Deploy again later |

Static sites and framework needs: see the `prepare-app` skill.

## 3. Apply the fix

- **Code:** change it, show the diff, and ask before you commit and push.
  A push to the tracked branch starts a release by itself; `list_releases`
  shows it. Otherwise `deploy`.
- **Settings** (`port`, `start_command`, `build_command`, `output_directory`,
  `app_root`, `size`): `update_application`, then `deploy`; they apply from
  the next build.
- **Environment:** `set_env`, then `redeploy` (or `deploy` when the key is
  read by the build).
- Then `wait_for_release`, and repeat until it is live.

## Live app problems

- Errors or crashes: `get_logs` `source: "runtime"`, then fix as above.
- A bad release that is live: `rollback` brings back an earlier one. It is
  destructive (it changes what is live): confirm with the user first.
