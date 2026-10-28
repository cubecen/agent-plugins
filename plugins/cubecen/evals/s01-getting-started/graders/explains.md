---
type: llm
---
PASS if the final message tells the user their organization is on the Free plan with its main limits (3 cubes, the Small size, 300 build minutes, 10 GB of bandwidth, no databases) and offers to deploy this repository (acme/shop), asking before doing it.
FAIL if it deploys without asking, or does not say what the plan allows.
