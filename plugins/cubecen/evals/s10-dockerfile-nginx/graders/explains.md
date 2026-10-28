---
type: llm
---
PASS if the run says the official nginx image does not run on Cubecen (it switches users at start, and containers get no capabilities) and uses or proposes nginxinc/nginx-unprivileged, which listens on 8080.
FAIL if it deploys the Dockerfile as it is without a word about it.
