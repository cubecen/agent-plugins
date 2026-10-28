---
type: llm
---
PASS if the run deals with the "vite preview" start script before or while deploying: it removes it, or sets output_directory to dist (so the built files are served), and says why.
FAIL if it deploys with "vite preview" as the start command without a word about it.
