Release bld_3 failed (DEPLOY_FAILED) at deployment dpl_3: APP_NOT_LISTENING: The app did not accept connections on port 8080
cause: the app ran but did not accept connections on its port
fix: listen on 0.0.0.0:$PORT, or set port
seen in the log: "10:04:12 [rollout] Listening on http://127.0.0.1:3000": the app seems to listen on localhost only: listen on 0.0.0.0
log (the last error lines of the deployment dpl_3):
  10:04:41 [rollout] Error: the app did not accept connections on port 8080 within 60s
  10:04:41 event Warning Unhealthy Pod/app-7784d-fk4jm: Readiness probe failed: dial tcp 10.42.1.17:8080: connect: connection refused
next: fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy; in the env: set_env, then redeploy); the app's own output: get_logs source runtime errors true; the whole log: get_logs source deployment id dpl_3

{
  "id": "bld_3",
  "build_id": "bld_3",
  "release_status": "DEPLOY_FAILED",
  "terminal": true,
  "error": {
    "code": "APP_NOT_LISTENING",
    "message": "The app did not accept connections on port 8080"
  },
  "diagnosis": {
    "stage": "deployment",
    "id": "dpl_3",
    "code": "APP_NOT_LISTENING",
    "message": "The app did not accept connections on port 8080",
    "cause": "the app ran but did not accept connections on its port",
    "fix": "listen on 0.0.0.0:$PORT, or set port",
    "hints": [
      {
        "line": "10:04:12 [rollout] Listening on http://127.0.0.1:3000",
        "hint": "the app seems to listen on localhost only: listen on 0.0.0.0"
      }
    ],
    "excerpt": [
      "10:04:41 [rollout] Error: the app did not accept connections on port 8080 within 60s",
      "10:04:41 event Warning Unhealthy Pod/app-7784d-fk4jm: Readiness probe failed: dial tcp 10.42.1.17:8080: connect: connection refused"
    ],
    "next": "fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy; in the env: set_env, then redeploy); the app's own output: get_logs source runtime errors true; the whole log: get_logs source deployment id dpl_3"
  },
  "deployment_id": "dpl_3"
}
