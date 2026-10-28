---
type: llm
focus: {source: file, path: routes/orders.js}
---
PASS if the handler no longer throws when the id query parameter is missing: it checks for a missing id (answering 400 or similar) or guards the trim call.
FAIL if req.query.id.trim() can still run when id is undefined.
