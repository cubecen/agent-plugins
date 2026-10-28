---
name: configure
description: Use when the user wants to set, change or remove environment variables or secrets on Cubecen, undo an env change, connect cubes to each other with references, turn pull request previews on or off, or give a cube more memory or a different size.
---

# Configure a Cubecen cube

## Variables and secrets

- `get_env` lists them; secrets show without values. `set_env` adds,
  changes or unsets keys: `secret: true` for passwords, tokens and keys
  (never shown again).
- `PORT` and `CUBECEN_*` are the platform's (`ENV_KEY_RESERVED`): the port
  is the cube's `port` setting (`update_application`).
- Keys the build reads (`VITE_`, `NEXT_PUBLIC_`, `PUBLIC_`, `REACT_APP_`,
  `NUXT_PUBLIC_`, `EXPO_PUBLIC_`, `GATSBY_`…) need `build: true`; they end
  up in the browser bundle, so never a secret.
- Changes apply with `redeploy` (the serving build again). After a failed
  release, or for a `build: true` key, `deploy` instead.
- References: `${{ <cube>.PUBLIC_URL }}`, `${{ <cube>.PRIVATE_URL }}` and
  `${{ <database>.DATABASE_URL }}` in a variable's value, between cubes and
  databases of one project; a broken one fails the next deploy with
  `ENV_REFERENCE_BROKEN`.
- Values the user has not given come from them: never invent one; ask
  before copying from a local `.env`, and never print a value.

## Undo an env change

`list_env_versions` (newest first), `diff_env` to show
the change, then ask to confirm `restore_env` to the version before it
(it is destructive), then `redeploy`.

## Previews

`list_previews` shows whether they are on. `set_previews` turns them on
(plans with previews), or off, which closes every open preview: confirm
first. A preview's logs: `get_logs` with `source: preview`.

## Size and memory

`get_organization` lists the plan's sizes. `update_application` with
`size` up to the plan's largest; it applies at once. Above
it, the answer is `PLAN_LIMIT_REACHED` with the plan page; a size not
offered right now is `SIZE_UNAVAILABLE`. Look at the code before buying
memory (`investigate` skill).

## Rules

- Destructive tools (`restore_env`, `set_previews`, `rollback`,
  `cancel_release`…): confirm with the user first.
- A refusal's `next:` line says what to do.
