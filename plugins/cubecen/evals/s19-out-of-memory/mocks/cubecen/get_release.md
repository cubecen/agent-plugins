Release bld_8 failed (DEPLOY_FAILED) at deployment dpl_8: APP_OUT_OF_MEMORY: The app went over its memory limit (2048 MiB)
cause: the app went over its size's memory
fix: fix the leak or the heavy start step, or a bigger size within the plan
seen in the log: "10:06:30 [rollout] FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory": out of memory
log (the last error lines of the deployment dpl_8):
  10:06:30 [rollout] FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory
  10:06:31 event Warning OOMKilling Pod/app-7784d-fk4jm: Memory cgroup out of memory: Killed process 1 (node)
next: fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy; in the env: set_env, then redeploy); the app's own output: get_logs source runtime errors true; the whole log: get_logs source deployment id dpl_8

{
  "id": "bld_8",
  "build_id": "bld_8",
  "release_status": "DEPLOY_FAILED",
  "terminal": true,
  "error": {
    "code": "APP_OUT_OF_MEMORY",
    "message": "The app went over its memory limit (2048 MiB)"
  },
  "diagnosis": {
    "stage": "deployment",
    "id": "dpl_8",
    "code": "APP_OUT_OF_MEMORY",
    "message": "The app went over its memory limit (2048 MiB)",
    "cause": "the app went over its size's memory",
    "fix": "fix the leak or the heavy start step, or a bigger size within the plan",
    "hints": [
      {
        "line": "10:06:30 [rollout] FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory",
        "hint": "out of memory"
      }
    ],
    "excerpt": [
      "10:06:30 [rollout] FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory",
      "10:06:31 event Warning OOMKilling Pod/app-7784d-fk4jm: Memory cgroup out of memory: Killed process 1 (node)"
    ],
    "next": "fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy; in the env: set_env, then redeploy); the app's own output: get_logs source runtime errors true; the whole log: get_logs source deployment id dpl_8"
  },
  "deployment_id": "dpl_8"
}
