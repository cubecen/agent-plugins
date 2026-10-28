# Other languages on Cubecen

Railpack detects these by their files. Each server listens on `0.0.0.0`
and the port in `PORT`. When the default start would not, set the cube's
`start_command` (it replaces the detected one) or change the code.

| Language | Detected by | Start that listens right |
|---|---|---|
| Python, Flask | `requirements.txt`, `pyproject.toml` | `gunicorn -b 0.0.0.0:$PORT app:app` (add `gunicorn`); `app.run()` alone listens on `127.0.0.1:5000` |
| Python, FastAPI | same | `uvicorn main:app --host 0.0.0.0 --port $PORT` |
| Python, Django | `manage.py` | `gunicorn <project>.wsgi -b 0.0.0.0:$PORT`; set `ALLOWED_HOSTS` and `CSRF_TRUSTED_ORIGINS` to the cube's host (and custom domains), and `SECRET_KEY` as a secret |
| Go | `go.mod` | `http.ListenAndServe(":"+os.Getenv("PORT"), …)` (`":"` listens on every address) |
| Ruby on Rails | `Gemfile` | `bundle exec rails server -b 0.0.0.0 -p $PORT`, or Puma with `port ENV.fetch("PORT")`; `SECRET_KEY_BASE` as a secret, `RAILS_ENV=production` |
| PHP, Laravel | `composer.json` | `APP_KEY` as a secret, `APP_ENV=production`; migrations in the start command |
| Java, Spring Boot | `pom.xml`, `build.gradle` | `server.port=${PORT:8080}` in `application.properties` |
| Rust | `Cargo.toml` | bind `0.0.0.0` and the port from `PORT` (`std::env::var("PORT")`) |
| Deno | `deno.json` | `Deno.serve({ hostname: "0.0.0.0", port: Number(Deno.env.get("PORT")) }, handler)` |
| Bun | `bun.lock`, `bun.lockb`, `bunfig.toml` | `Bun.serve({ hostname: "0.0.0.0", port: Number(process.env.PORT), fetch })` |

- `start_command` runs with `/bin/sh -c`: `$PORT` expands there.
- A language version is chosen the usual way (`.python-version`,
  `go.mod`'s `go` line, `.ruby-version`, `engines.node`).
- When Railpack cannot tell how to build the app (`BUILD_NOT_DETECTED`),
  check `app_root` first, then add a `Dockerfile`
  (`references/dockerfile.md`).
