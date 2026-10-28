# Cubecen plugins for coding agents

Deploy the app you are working on to [Cubecen](https://cubecen.com) from
Claude Code or Codex: the agent checks the app, deploys it from GitHub,
wires a Postgres database and a domain, and when something breaks it reads
the diagnosis, the logs and the metrics, and fixes the cause in your code.

The plugin connects your agent to the Cubecen MCP server
(`https://mcp.cubecen.com/mcp`) and adds these skills:

| Skill | What it does |
|---|---|
| `getting-started` | Your organization, role, plan and limits; connects GitHub when needed; your first deploy; how much of the plan you used |
| `deploy` | Deploys the current repository and gives back its live URL: finds the GitHub repository, the app's folder and its cube, asks before it commits or pushes, waits for the pushed commit's release; several apps in one repository |
| `prepare-app` | Checks the app will build and run on Cubecen (port, start command, framework settings, Dockerfile) and fixes what would fail |
| `fix-deploy` | Reads a failed build's or deployment's diagnosis and logs, explains the cause and fixes it in the code, the cube's settings or its environment |
| `investigate` | A live app that errors, is slow or restarts: metrics, then the error logs, the code at fault, the fix; a rollback when a release broke it |
| `configure` | Environment variables and secrets, build-time variables, references between cubes, undoing an env change, previews, sizes |
| `database` | Managed Postgres: creates it, wires `DATABASE_URL`, runs migrations (Prisma, Drizzle, Django, Rails, Alembic…) |
| `domain` | A custom domain: the DNS records at your registrar (Cloudflare, Namecheap, GoDaddy, Route 53…), verification and HTTPS |

After a `git push`, a hook reminds the agent that the push started a
release, so it waits for that commit's release instead of guessing.

## Claude Code

```
/plugin marketplace add cubecen/agent-plugins
/plugin install cubecen@cubecen
```

Then run `/mcp`, choose `plugin:cubecen:cubecen` and sign in to Cubecen.
Ask "deploy this app to Cubecen", or run `/cubecen:deploy`.

If you added the Cubecen MCP server by hand before (`claude mcp add cubecen …`),
remove it (`claude mcp remove cubecen`) so the tools are not listed twice.

## Codex

```
codex plugin marketplace add cubecen/agent-plugins
```

Then open `/plugins` in Codex, install Cubecen and sign in when asked.
Codex asks you to trust the plugin's hook before it runs.
Ask "deploy this app to Cubecen".

## Other agents

Cursor, Kiro, VS Code and other MCP clients can use the server directly:
see [cubecen.com/docs](https://cubecen.com/docs).

## How it works

- Cubecen builds from GitHub, so the agent deploys what is pushed; it asks
  before it commits, pushes or creates a repository.
- Public repositories deploy right away. For a private repository the agent
  gives you a link to connect GitHub once.
- Deleting, rolling back and other destructive tools ask you first.
  Passwords and secrets are never printed.

## Developing the plugin

- `sh tests/check.sh` validates the manifests, the skills, the eval cases
  and the hook.
- `scripts/sync-tools.sh <cubecen-backend checkout>` copies the MCP server's
  tool list into the eval mocks after the server's tools change.
- Evals run with `claude plugin eval` (Claude Code 2.1.269 or later). Each
  run calls the model with your Claude account, so it counts against your
  usage:

  ```
  claude plugin eval plugins/cubecen --scaffold --trust-plugin \
    --allow-tools "Bash(git *)" Edit Write \
    --model sonnet --judge-model sonnet --no-publish
  ```

  Add `--tag probe --runs 1` for a quick, cheap check of two cases.

## License

MIT
