---
name: prepare-app
description: Use when an app is about to be deployed to Cubecen for the first time, or the user asks whether it is ready for Cubecen or which settings it needs (port, start command, build command, output directory, app root, Dockerfile).
---

# Prepare an app for Cubecen

Read the app; do not guess. Then report in a short list: what already works,
what you changed or propose to change, and the settings to pass to
`create_application` or `update_application`. Change the user's code only
with their agreement; settings are not code changes.

## How Cubecen builds and runs

- The build runs in the app's folder (`app_root`; the repository root by
  default) from the commit on GitHub, for `linux/amd64`.
- A file named exactly `Dockerfile` there is built, and nothing else is
  tried: read `references/dockerfile.md`. Otherwise Railpack detects the
  language and framework; when neither works the build fails with
  `BUILD_NOT_DETECTED`.
- Every server listens on `0.0.0.0` (not `localhost` or `127.0.0.1`) and on
  the port in `PORT` (8080). An app with a fixed port reads `PORT`, or the
  cube's `port` is set to it.
- Memory is the size's (Small 2 GiB, Medium 4 GiB, Large 8 GiB); more ends
  in `APP_OUT_OF_MEMORY`. The filesystem is not kept between deploys:
  uploads and SQLite files belong in Postgres (`database` skill) or object
  storage. Containers get no Linux capabilities.

## Checks, in order

1. **Which app, where.** Find the folder with the app's marker
   (`package.json`, `requirements.txt`, `pyproject.toml`, `go.mod`,
   `Gemfile`, `composer.json`, `pom.xml`, `build.gradle`, `Cargo.toml`,
   `deno.json`, `Dockerfile`, `index.html`); that is `app_root`.
2. **What it is.** A static site or SPA, an SSR framework or a Node server:
   read `references/frameworks.md`. Python, Go, Ruby, PHP, Java, Rust,
   Deno or Bun: read `references/languages.md`.
3. **How it starts.** Find the start command and what it listens on. Fix
   what would bind localhost or a fixed port.
4. **What it needs.** Variables it reads without a default (the `deploy`
   skill sets them), a database, files it writes.

## Common mistakes

- `"start": "vite preview"` or `serve` on a static site: Railpack runs it
  instead of serving the built files; remove it or set
  `output_directory`.
- A server that logs `listening on http://localhost:3000`: it fails with
  `APP_NOT_LISTENING`.
- SvelteKit with `adapter-auto`: builds, then crashes at start.
- The official `nginx` image: does not run; use
  `nginxinc/nginx-unprivileged`.

## Rules

- Never commit or push without the user's yes.
