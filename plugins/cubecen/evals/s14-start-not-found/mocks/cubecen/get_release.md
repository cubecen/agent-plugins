Release bld_4 failed (BUILD_FAILED): START_COMMAND_NOT_FOUND: No start command: add a start script to package.json or set a start command
cause: nothing to run: no start script and no start command
fix: add a start script, set start_command, or for a static site set output_directory
seen in the log: "10:01:02 [plan] npm ERR! Missing script: "start"": no start script in package.json
log (the last error lines of the build bld_4):
  10:01:02 [plan] npm ERR! Missing script: "start"
next: fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy); the whole log: get_logs source build id bld_4

{
  "id": "bld_4",
  "build_id": "bld_4",
  "release_status": "BUILD_FAILED",
  "terminal": true,
  "error": {
    "code": "START_COMMAND_NOT_FOUND",
    "message": "No start command: add a start script to package.json or set a start command"
  },
  "diagnosis": {
    "stage": "build",
    "id": "bld_4",
    "code": "START_COMMAND_NOT_FOUND",
    "message": "No start command: add a start script to package.json or set a start command",
    "cause": "nothing to run: no start script and no start command",
    "fix": "add a start script, set start_command, or for a static site set output_directory",
    "hints": [
      {
        "line": "10:01:02 [plan] npm ERR! Missing script: \"start\"",
        "hint": "no start script in package.json"
      }
    ],
    "excerpt": [
      "10:01:02 [plan] npm ERR! Missing script: \"start\""
    ],
    "next": "fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy); the whole log: get_logs source build id bld_4"
  }
}
