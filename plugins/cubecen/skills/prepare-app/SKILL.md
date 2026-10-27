---
name: prepare-app
description: Check that the app in the current repository will build and run on Cubecen, and fix what would fail. Use before a first Cubecen deploy, when the user asks whether their app is ready for Cubecen, or which Cubecen settings (port, start command, build command, output directory, app root) it needs.
---

# Prepare an app for Cubecen

Read the app; do not guess. Report what you found as a short list: what
already works, what you changed or propose to change, and the settings to
pass to `create_application`. Change the user's code only with their
agreement; settings are not code changes.

## How Cubecen builds

- The build runs in the app's folder (`app_root`, the repository root by
  default), for `linux/amd64`, from the commit on GitHub.
- A file named exactly `Dockerfile` in that folder: it is built, and nothing
  else is tried. Otherwise Railpack detects the language and framework.
  Neither works: the build fails with `BUILD_NOT_DETECTED`.
- Monorepo: an app's folder has a `Dockerfile`, `package.json`, `deno.json`,
  `go.mod`, `requirements.txt`, `pyproject.toml`, `Gemfile`, `Cargo.toml` or
  similar. `get_repository_folders` lists the folders on GitHub.

## Every server

- Listen on `0.0.0.0` (not `localhost` or `127.0.0.1`) on the port in
  `$PORT`, 8080 by default. When the app has a fixed port, either read
  `PORT` or set the cube's `port` to it. `HOST` is `0.0.0.0` unless set.
- Memory: Small 2 GiB, Medium 4 GiB, Large 8 GiB; more ends in
  `APP_OUT_OF_MEMORY`.
- The filesystem is not kept between deploys: uploads and SQLite files are
  lost. Suggest Postgres (`create_database`) or an object store.
- Containers have no Linux capabilities. The official `nginx` image does not
  run; `nginxinc/nginx-unprivileged` does.

## Railpack (no Dockerfile)

- Node.js: a server needs a `start` script in `package.json`; without one
  the build fails with `START_COMMAND_NOT_FOUND`. Node 24 by default; another
  through `engines.node`, `.nvmrc` or `RAILPACK_NODE_VERSION`.
- `build_command` replaces the detected build. It is split into words
  without a shell: `npm run build:prod` works, `a && b` does not (put it in a
  `package.json` script).
- Static sites and SPAs are served as files, with `index.html` for unknown
  paths: Vite (`dist`), Create React App (`build`), Astro static (`dist`),
  Next.js `output: "export"` (`out`), React Router `ssr: false`
  (`build/client`), plain HTML. A `start` script such as `vite preview`
  makes Railpack run it instead: remove it, or set `output_directory`.
- Other generators (Docusaurus, Gatsby, VitePress, Eleventy…): set
  `output_directory` (`build`, `public`, `.vitepress/dist`, `_site`) and, if
  needed, `build_command`.
- Angular 17+: set `output_directory` to `dist/<project>/browser`.
- Servers: Next.js (`next start`), Nuxt, Remix, React Router 7 and TanStack
  Start work as they are. SvelteKit needs `@sveltejs/adapter-node` and
  `"start": "node build"` (adapter-auto builds, then crashes at start).
  Astro SSR needs `@astrojs/node` in `standalone` mode and
  `"start": "node ./dist/server/entry.mjs"`.
- Python, Go, Ruby, PHP, Java, Rust, Deno, Bun and others: Railpack detects
  them; make sure the start command listens on `0.0.0.0:$PORT` (for example
  `gunicorn -b 0.0.0.0:$PORT app:app`, `uvicorn main:app --host 0.0.0.0
  --port $PORT`). Set `start_command` when the default would not start it.

## Dockerfile

- The last stage is built. `# syntax=` is ignored (no `1-labs` features).
- Port: the cube's `port` wins; else a single `EXPOSE` port; else 8080.
- `start_command`, when set, replaces `ENTRYPOINT`/`CMD` and runs with
  `/bin/sh -c`: distroless and `scratch` images then fail with
  `START_COMMAND_NEEDS_SHELL`. Leave it empty to run the image's command.
- Build-time values: variables arrive as `ARG NAME`; every value, secrets
  too, as a secret mount (`RUN --mount=type=secret,id=NAME,env=NAME`).
  Secrets are never build args.
- Only the app's folder is the build context; `.dockerignore` applies.

## Environment

- List what the app reads and what has no default; these must be set with
  `set_env` before the first deploy (see the `deploy` skill).
- Values the build reads (public browser prefixes such as `VITE_` and
  `NEXT_PUBLIC_`, or anything the build step uses) need `build: true`.
- Cubecen sets `PORT` and `CUBECEN_*` variables itself.
