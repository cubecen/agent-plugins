# Symptoms and their usual causes

| Symptom | Read | Usual causes |
|---|---|---|
| 500s on some routes | `get_logs` `errors: true` | an exception on unexpected input (a missing parameter, an undefined property), a database error, a variable read only at request time, an upstream API failing |
| 500s on every route | the same, and the last release | a bad deploy (the errors start at the release's time), the database unreachable or its password reset (redeploy the cubes that use it), a missing variable |
| Slow responses, CPU at its limit | `get_metrics`, `get_logs` `search` | synchronous work per request (loops, hashing, image or PDF work, huge JSON), no caching |
| Slow responses, CPU low | `get_logs` `search: timeout` | slow database queries (N+1, a missing index), external calls without timeouts, a connection pool too small |
| Restarts, memory at its limit | events `OOMKilled` | a cache or map that grows forever, whole files or results held in memory, a heap larger than the container (Java) |
| Restarts, memory fine | events `BackOff`, the crash's stack | an unhandled exception or promise rejection at runtime, the process exiting on an error |
| Down: no response at all | `list_applications`, `get_metrics` | a paused cube (bandwidth used up on Free), a crash loop, a custom domain's DNS (the `cubecen.app` URL still works) |

A failed deploy never takes an app down: the previous release keeps
serving. "Down" after a deploy that succeeded is the new code.

## Signs per stack

- **Node.js**: `TypeError: Cannot read properties of undefined`;
  `UnhandledPromiseRejection` (ends the process); `JavaScript heap out of
  memory`; `ECONNREFUSED …:5432`.
- **Python**: `Traceback (most recent call last)`; gunicorn `WORKER
  TIMEOUT` (a request over 30 s; the worker is killed); `MemoryError`.
- **Go**: `panic: runtime error: invalid memory address or nil pointer
  dereference`; goroutines that never end (memory grows).
- **Ruby**: `NoMethodError … for nil`; Puma worker timeouts.
- **Java**: `OutOfMemoryError: Java heap space` (set
  `-XX:MaxRAMPercentage=75` so the heap fits the container);
  `NullPointerException`.
