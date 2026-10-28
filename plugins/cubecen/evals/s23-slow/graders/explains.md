---
type: llm
---
PASS if the final message says the cube's CPU is at its limit (500 m) with p95 latency around 2.5 s, traces it to the prime counting that runs on every /api/report request (routes/report.js), and proposes a code fix (cache it, compute it ahead or off the request) and/or a bigger size.
FAIL if it only proposes a bigger size without looking at the metrics or the code.
