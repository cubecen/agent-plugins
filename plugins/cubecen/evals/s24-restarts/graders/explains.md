---
type: llm
---
PASS if the final message says the restarts are out-of-memory kills (quoting the OOMKilling event or the heap out of memory error, memory at 100% of its limit) and points at the Map in server.js that keeps every response forever as the cause, proposing to bound or drop it.
FAIL if it only proposes a bigger size, or a rollback, without naming the leak.
