---
type: llm
---
PASS if the final message names the start step in server.js that loads the catalog and clones it 200 times as what fills the memory, and proposes loading less (or lazily) and/or a bigger size within the plan.
FAIL if it only says to raise the memory without looking at the code, or deletes or rolls back anything.
