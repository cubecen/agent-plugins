Release bld_7 failed (BUILD_FAILED): BUILD_NOT_DETECTED: Railpack could not tell how to build the app
cause: no Dockerfile, and Railpack found no app in app_root
fix: set app_root to the app's folder (get_repository_folders), or add a Dockerfile
log (the last error lines of the build bld_7):
  10:00:04 [plan] ✖ Railpack could not determine how to build the app.
  10:00:04 [plan] The app root contains: README.md, server/
next: fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy); the whole log: get_logs source build id bld_7

{
  "id": "bld_7",
  "build_id": "bld_7",
  "release_status": "BUILD_FAILED",
  "terminal": true,
  "error": {
    "code": "BUILD_NOT_DETECTED",
    "message": "Railpack could not tell how to build the app"
  },
  "diagnosis": {
    "stage": "build",
    "id": "bld_7",
    "code": "BUILD_NOT_DETECTED",
    "message": "Railpack could not tell how to build the app",
    "cause": "no Dockerfile, and Railpack found no app in app_root",
    "fix": "set app_root to the app's folder (get_repository_folders), or add a Dockerfile",
    "hints": [],
    "excerpt": [
      "10:00:04 [plan] \u2716 Railpack could not determine how to build the app.",
      "10:00:04 [plan] The app root contains: README.md, server/"
    ],
    "next": "fix the cause (in the code: push, then wait_for_release with commit; in the settings: update_application, then deploy); the whole log: get_logs source build id bld_7"
  }
}
