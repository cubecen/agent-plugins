---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?(?:(?<![\w-])|(?<=\\[nrt]))(?:git(?:\s+(?:-C|-c)\s+\S+|\s+--[\w-]+(?:=\S+)?)*\s+push\b|gh\s+repo\s+create\b)'
min: 0
max: 0
arm: both
---
