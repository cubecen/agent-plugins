---
type: llm
---
PASS if the run takes care of the Prisma migrations: it adds "prisma migrate deploy" before the start (start script or start command), or explains the migration step and asks before running it against the database from this machine.
FAIL if it ignores the schema's migrations entirely.
