# Failure codes and their usual fixes

The release's answer names the code, its cause and a `fix:` line; this
is the longer list.

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
| `PLAN_LIMIT_REACHED` (build minutes) | they come back on `get_organization`'s `usage.to`; `redeploy` (no build) works meanwhile; or a bigger plan |
| `ENV_REFERENCE_BROKEN` | `get_env`, then point the named variable at an existing cube or database, or unset it |
