# JavaScript frameworks on Cubecen (Railpack, no Dockerfile)

## Static sites and SPAs

Railpack builds them and serves the output folder on `PORT`, with
`index.html` for paths that match no file.

| Framework | Detected by | Folder served |
|---|---|---|
| Vite (React, Vue, Svelte, Solid…) | `vite.config.*`, or `vite build` in the build script | `dist` |
| Create React App | `react-scripts build` | `build` |
| Angular 17+ | `angular.json` | set `output_directory` to `dist/<project>/browser` (else the build fails at `copy /app/browser: not found`) |
| Astro, static | `astro.config.*` without `output: "server"` | `dist` |
| Next.js static export | `output: "export"` | `out` |
| React Router, SPA mode | `ssr: false` | `build/client` |
| Plain HTML | `index.html`, a `public/` folder or a `Staticfile` | that folder |
| Docusaurus, Gatsby, VitePress, Eleventy… | not detected | set `output_directory` (`build`, `public`, `.vitepress/dist`, `_site`) and, if needed, `build_command` |

- A `start` script other than the framework's own (`vite preview`,
  `serve -s dist`, `http-server`) makes Railpack run it instead: remove it,
  or set `output_directory` (which wins and serves the files).
- `output_directory` cannot be combined with `start_command`.

## Servers (SSR and APIs)

They run their `start` script and listen on `0.0.0.0:$PORT` (`HOST` is
`0.0.0.0` unless the env sets it).

| Framework | What it needs |
|---|---|
| Next.js | the default `"start": "next start"` |
| Nuxt | nothing: Railpack runs `.output/server/index.mjs` |
| Remix, React Router 7 | the default `start` script |
| SvelteKit | `@sveltejs/adapter-node` in `svelte.config.js` and `"start": "node build"`; with `adapter-auto` the build succeeds and the app crashes at start (exit 1) |
| Astro SSR | `@astrojs/node` in `standalone` mode and `"start": "node ./dist/server/entry.mjs"` |
| TanStack Start | nothing |
| Express, Koa, Hono | `listen(process.env.PORT, "0.0.0.0")` |
| Fastify | `listen({ port: Number(process.env.PORT), host: "0.0.0.0" })`: its default host is `127.0.0.1` |
| NestJS | `app.listen(process.env.PORT, "0.0.0.0")` |

## Build settings

- No `start` script and no `start_command`: `START_COMMAND_NOT_FOUND`.
- `build_command` replaces the detected build. It is split into words
  without a shell: `npm run build:prod` works, `a && b` does not (put the
  steps in a `package.json` script).
- Node.js is 24 by default; choose another with `engines.node`, `.nvmrc`
  or `RAILPACK_NODE_VERSION`.
- Values with a public prefix (`VITE_`, `NEXT_PUBLIC_`, `PUBLIC_`,
  `REACT_APP_`, `NUXT_PUBLIC_`, `EXPO_PUBLIC_`, `GATSBY_`) are copied into
  the bundle at build time: they need `build: true`, a new build
  (`deploy`, not `redeploy`) when they change, and never a secret.
- `RAILPACK_*` variables steer Railpack; `build_command` and
  `output_directory` win over `RAILPACK_BUILD_CMD` and
  `RAILPACK_SPA_OUTPUT_DIR`.
