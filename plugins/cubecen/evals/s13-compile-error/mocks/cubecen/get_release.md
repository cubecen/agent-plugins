Release bld_9 failed (BUILD_FAILED): WORKFLOW_EXECUTION_FAILED: The build step failed
cause: a build step failed (the message names it): a compile or test error, an install error, a missing build-time variable
fix: read the log lines below, fix the code, or set the variable with build: true
seen in the log: "10:02:11 [build] ./main.go:12:23: undefined: handler": a compile error in the code: the line names the file
log (the last error lines of the build bld_9):
  10:02:11 [build] # acme/shop
  10:02:11 [build] ./main.go:12:23: undefined: handler
  10:02:11 [build] ERROR: failed to build: exit code: 1
next: fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy); the whole log: get_logs source build id bld_9

{
  "id": "bld_9",
  "build_id": "bld_9",
  "release_status": "BUILD_FAILED",
  "terminal": true,
  "error": {
    "code": "WORKFLOW_EXECUTION_FAILED",
    "message": "The build step failed"
  },
  "diagnosis": {
    "stage": "build",
    "id": "bld_9",
    "code": "WORKFLOW_EXECUTION_FAILED",
    "message": "The build step failed",
    "cause": "a build step failed (the message names it): a compile or test error, an install error, a missing build-time variable",
    "fix": "read the log lines below, fix the code, or set the variable with build: true",
    "hints": [
      {
        "line": "10:02:11 [build] ./main.go:12:23: undefined: handler",
        "hint": "a compile error in the code: the line names the file"
      }
    ],
    "excerpt": [
      "10:02:11 [build] # acme/shop",
      "10:02:11 [build] ./main.go:12:23: undefined: handler",
      "10:02:11 [build] ERROR: failed to build: exit code: 1"
    ],
    "next": "fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy); the whole log: get_logs source build id bld_9"
  }
}
