Release bld_12 failed (DEPLOY_FAILED) at deployment dpl_12: QUOTA_EXCEEDED: The platform had no room for the app's pods
cause: the platform had no room right now; not the app's fault
fix: deploy again in a few minutes
log (the last error lines of the deployment dpl_12):
  10:07:00 event Warning FailedCreate ReplicaSet/app-7784d: exceeded quota: apps-total
next: deploy again in a few minutes; the whole log: get_logs source deployment id dpl_12

{
  "id": "bld_12",
  "build_id": "bld_12",
  "release_status": "DEPLOY_FAILED",
  "terminal": true,
  "error": {
    "code": "QUOTA_EXCEEDED",
    "message": "The platform had no room for the app's pods"
  },
  "diagnosis": {
    "stage": "deployment",
    "id": "dpl_12",
    "code": "QUOTA_EXCEEDED",
    "message": "The platform had no room for the app's pods",
    "cause": "the platform had no room right now; not the app's fault",
    "fix": "deploy again in a few minutes",
    "hints": [],
    "excerpt": [
      "10:07:00 event Warning FailedCreate ReplicaSet/app-7784d: exceeded quota: apps-total"
    ],
    "next": "deploy again in a few minutes; the whole log: get_logs source deployment id dpl_12"
  },
  "deployment_id": "dpl_12"
}
