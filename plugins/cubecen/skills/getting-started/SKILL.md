---
name: getting-started
description: Use when the user is new to Cubecen or asks to set it up, asks about their organization, role, plan or limits, how much of their plan they used this month (build minutes, bandwidth, cubes), or what is running on Cubecen.
---

# Getting started with Cubecen

## Where they stand

`get_organization` answers the role, what they may do through the agent
(`can`), the plan with its limits and what is used, and dashboard links.
Tell them in a few lines:

- the plan and its main limits beside what is used: cubes, the largest
  size, build minutes and bandwidth this period, databases (Free has none);
- paused cubes and why, when there are any;
- for more, the plan page (`links.plan`) and the usage page (`links.usage`).

A question about usage is answered from the same call; do not guess
numbers.

## What is running

`list_applications` answers one line per cube: state, URL, last release.
Name each cube; point out a failed last release (its `get_release` call is
in the line) and a paused cube.

## The first deploy

- Public repositories deploy as they are. Private ones need GitHub
  connected once: `connect_github` gives the link to give the user.
- Offer to deploy the current repository; when the user says yes, follow
  the `deploy` skill. Create nothing before that yes.

## Rules

- A bigger plan, more cubes, previews or databases, teammates or API keys:
  the `team-and-account` skill (owners ask for Launch or Scale through it).
- No Cubecen tools listed: the MCP server is not signed in; ask the user to
  sign in (Claude Code: `/mcp`; Codex: `/plugins`).
