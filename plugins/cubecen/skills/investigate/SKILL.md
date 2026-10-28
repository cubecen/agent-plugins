---
name: investigate
description: Use when a live app on Cubecen returns errors or 500s, is down, slow or timing out, keeps restarting or crashing after it deployed, or a release that went live broke something and the user wants the previous version back.
---

# Investigate a live Cubecen app

Measure first, then read the logs, then the code. Do not guess.

## 1. The cube

`list_applications` with `repository: "owner/name"`; with several cubes
and no hint, ask which. A cube the line says is paused is not broken:
`get_organization`'s `plan.suspension` says why and until when; follow the
`team-and-account` skill instead of the steps below.

## 2. Metrics

`get_metrics` (`range: 1h`; `24h` for "today"): the 5xx share and when it
peaked, p95 latency, restarts, CPU and memory against their limits.

## 3. Logs

- Errors and 500s: `get_logs` with `source: runtime`, `errors: true`,
  `since: 1h` (or since the peak). Each error comes with its stack trace's
  next lines.
- Slowness: `search` for the slow route or `timeout`.
- Restarts: `errors: true` shows the Kubernetes events (`OOMKilled`,
  `BackOff`) and the crash.

`references/symptoms.md` maps each symptom to its usual causes per stack.

## 4. The cause

Open the file and line the stack trace names. Explain the cause in one or
two sentences, quoting the log line.

## 5. The fix

- Code: change it and show the change; ask before you commit and push.
  After the push, `wait_for_release` with `commit`, then `get_metrics`
  again to show the errors falling.
- Environment or settings: as the `fix-deploy` skill says.
- Not enough capacity for the work: a bigger size (`configure` skill),
  after the code has been looked at.

## 6. Report

Your last message is the report, in this order:

1. **What is wrong**: the numbers that show it (5xx share, latency,
   restarts, memory), and since when.
2. **Cause**: one or two sentences, quoting the log line and naming the
   file and line.
3. **Change**: what you changed, or the change you propose when you made
   none.
4. **Next**: the commit and push you ask for, the release to wait for, or
   what the user must decide.

## 7. A bad release, back

When the live release broke it and the user wants the previous version:
`list_releases`, take the last good release before the live one, tell the
user which (when, commit, who), that it brings back the variables that
release shipped with (old secret values too), and ask to confirm. Only
then `rollback`,
and `wait_for_release`. The broken commit stays on the branch: fix forward
afterwards.

## Rules

- Never commit, push or roll back without the user's yes.
- Logs may hold secrets the app printed: never repeat them.
