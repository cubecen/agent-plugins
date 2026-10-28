# Dockerfiles on Cubecen

- A file named exactly `Dockerfile` (not `dockerfile`, not
  `Dockerfile.prod`) in the app's folder (`app_root`) is built with that
  folder as the context; `.dockerignore` applies. The last stage is built,
  for `linux/amd64`: an image for another CPU fails with
  `exec format error`.
- `# syntax=` is ignored: BuildKit's built-in frontend builds every
  Dockerfile, so `docker/dockerfile:1-labs` features are not available.
  `RUN` steps reach the internet, not the private network.
- A failed Dockerfile build does not fall back to Railpack.

## The port

The cube's `port` setting wins; else a single `EXPOSE` port (the app gets
it as `PORT`); else the app listens on `PORT`, 8080. Ports below 1024
work.

## The start

- An empty `start_command` runs the image's `ENTRYPOINT`/`CMD`.
- A set `start_command` replaces them and runs with `/bin/sh -c`: images
  without a shell (distroless, `scratch`) fail with
  `START_COMMAND_NEEDS_SHELL`. Clear the setting, or use an image with a
  shell.

## Build-time values

- Variables arrive as build args: `ARG NAME` in the Dockerfile.
- Every value, secrets too, is a secret mount:
  `RUN --mount=type=secret,id=NAME,env=NAME …`. Secrets are never build
  args (build args stay in the image's history).
- A changed secret does not rebuild cached steps that read it.

## Runtime

Containers run without Linux capabilities and cannot gain privileges,
though they may run as root. The official `nginx` image switches users at
start and fails: use `nginxinc/nginx-unprivileged` (it listens on 8080),
for example `FROM nginxinc/nginx-unprivileged:1.27-alpine`.
