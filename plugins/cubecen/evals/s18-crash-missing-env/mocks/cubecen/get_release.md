Release bld_2 failed (DEPLOY_FAILED) at deployment dpl_2: APP_CRASHED: The app exited with code 1
cause: the app exited (the message has the exit code)
fix: read the log lines below: often a missing variable, a database it cannot reach or a wrong start command
seen in the log: "10:05:03 [rollout] Error: API_TOKEN is not set": a variable is missing: set_env it
log (the last error lines of the deployment dpl_2):
  10:05:03 [rollout] Error: API_TOKEN is not set
  10:05:03 [rollout]     at Object.<anonymous> (/app/server.js:2:35)
  10:05:04 event Warning BackOff Pod/app-7784d-fk4jm: Back-off restarting failed container app
next: fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy; in the env: set_env, then redeploy); the app's own output: get_logs source runtime errors true; the whole log: get_logs source deployment id dpl_2

{
  "id": "bld_2",
  "build_id": "bld_2",
  "release_status": "DEPLOY_FAILED",
  "terminal": true,
  "error": {
    "code": "APP_CRASHED",
    "message": "The app exited with code 1"
  },
  "diagnosis": {
    "stage": "deployment",
    "id": "dpl_2",
    "code": "APP_CRASHED",
    "message": "The app exited with code 1",
    "cause": "the app exited (the message has the exit code)",
    "fix": "read the log lines below: often a missing variable, a database it cannot reach or a wrong start command",
    "hints": [
      {
        "line": "10:05:03 [rollout] Error: API_TOKEN is not set",
        "hint": "a variable is missing: set_env it"
      }
    ],
    "excerpt": [
      "10:05:03 [rollout] Error: API_TOKEN is not set",
      "10:05:03 [rollout]     at Object.<anonymous> (/app/server.js:2:35)",
      "10:05:04 event Warning BackOff Pod/app-7784d-fk4jm: Back-off restarting failed container app"
    ],
    "next": "fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy; in the env: set_env, then redeploy); the app's own output: get_logs source runtime errors true; the whole log: get_logs source deployment id dpl_2"
  },
  "deployment_id": "dpl_2"
}
