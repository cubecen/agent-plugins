---
type: llm
---
PASS if the run names the cause (the app is in the server/ folder, so Cubecen found nothing to build at the repository root) and either sets app_root to server with update_application or tells the user that app_root must be server and offers to set it.
FAIL if it names another cause, or changes the code instead of the setting.
