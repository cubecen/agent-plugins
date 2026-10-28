Release bld_6 failed (BUILD_FAILED): WORKFLOW_EXECUTION_FAILED: The build step failed
cause: a build step failed (the message names it): a compile or test error, an install error, a missing build-time variable
fix: read the log lines below, fix the code, or set the variable with build: true
seen in the log: "10:03:20 [build] Error: NEXT_PUBLIC_API_URL is not set": a variable is missing: set_env it
log (the last error lines of the build bld_6):
  10:03:20 [build] Error: NEXT_PUBLIC_API_URL is not set
  10:03:20 [build]     at Object.<anonymous> (/app/next.config.js:1:56)
next: fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy); the whole log: get_logs source build id bld_6

{
  "id": "bld_6",
  "build_id": "bld_6",
  "release_status": "BUILD_FAILED",
  "terminal": true,
  "error": {
    "code": "WORKFLOW_EXECUTION_FAILED",
    "message": "The build step failed"
  },
  "diagnosis": {
    "stage": "build",
    "id": "bld_6",
    "code": "WORKFLOW_EXECUTION_FAILED",
    "message": "The build step failed",
    "cause": "a build step failed (the message names it): a compile or test error, an install error, a missing build-time variable",
    "fix": "read the log lines below, fix the code, or set the variable with build: true",
    "hints": [
      {
        "line": "10:03:20 [build] Error: NEXT_PUBLIC_API_URL is not set",
        "hint": "a variable is missing: set_env it"
      }
    ],
    "excerpt": [
      "10:03:20 [build] Error: NEXT_PUBLIC_API_URL is not set",
      "10:03:20 [build]     at Object.<anonymous> (/app/next.config.js:1:56)"
    ],
    "next": "fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy); the whole log: get_logs source build id bld_6"
  }
}
