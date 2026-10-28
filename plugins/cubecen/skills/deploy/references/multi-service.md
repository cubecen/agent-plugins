# Several apps in one repository

## Cubes

- `get_repository_folders` lists the repository's folders with what marks
  an app (`Dockerfile`, `package.json`, `go.mod`, `pyproject.toml`…).
- One cube per app: `create_application` with the same `repository`, its
  folder as `app_root`, and `name` set to the folder (`web`, `api`): left
  out, every cube is named after the repository.
- Create them with `deploy: false`, set their variables, then deploy.

## Wiring them

References resolve when a cube builds or deploys; the env shows them as
written. They work in variables (not secrets) and between cubes of the
same project:

| Need | Variable | Value |
|---|---|---|
| The browser calls the API | `VITE_API_URL` (or `NEXT_PUBLIC_API_URL`…), `build: true` | `${{ api.PUBLIC_URL }}` |
| The API allows the web's origin (CORS) | `FRONTEND_URL` | `${{ web.PUBLIC_URL }}` |
| A server calls another inside the project | `API_INTERNAL_URL` | `${{ api.PRIVATE_URL }}` |
| A cube uses the database | `DATABASE_URL` | `${{ db.DATABASE_URL }}` |

- `PUBLIC_URL` is `https://<host>.cubecen.app`; it never changes, so a
  cube may refer to one not deployed yet. `PUBLIC_HOST` is the host alone.
- `PRIVATE_URL` is plain HTTP on port 80 inside the cluster: for
  server-to-server calls only, never in a key the browser reads. It works
  once both cubes deployed with the private network on; before, `set_env`
  refuses it.
- A slug that another cube's env uses cannot be renamed; a deleted cube's
  references fail the next deploy with `ENV_REFERENCE_BROKEN`.

## Order and pushes

- Deploy the database first (wait for `ready`), then the API, then the web.
- Every cube tracks a branch: one push starts a release per cube of the
  repository. Wait for each with `wait_for_release` and `commit`.
