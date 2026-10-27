# Cubecen plugins for coding agents

Deploy the app you are working on to [Cubecen](https://cubecen.com) from
Claude Code or Codex: the agent checks the app, deploys it from GitHub, wires
a Postgres database, and fixes a failed deploy from its logs.

The plugin connects your agent to the Cubecen MCP server
(`https://mcp.cubecen.com/mcp`) and adds three skills:

| Skill | What it does |
|---|---|
| `deploy` | Deploys the current repository and gives back its live URL: finds the GitHub repository and app folder, creates the cube or deploys the existing one, sets environment variables and a database, waits for the release |
| `prepare-app` | Checks the app will build and run on Cubecen (port, start command, framework settings, Dockerfile) and fixes what would fail |
| `fix-deploy` | Reads the failed build's or deployment's logs, explains the cause and fixes it in the code or the cube's settings |

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
Ask "deploy this app to Cubecen".

## Other agents

Cursor, Kiro, VS Code and other MCP clients can use the server directly:
see [cubecen.com/docs](https://cubecen.com/docs).

## How it works

- Cubecen builds from GitHub, so the agent deploys what is pushed; it asks
  before it commits or pushes.
- Public repositories deploy right away. For a private repository the agent
  gives you a link to connect GitHub once.
- Deleting, rolling back and other destructive tools ask you first.

## License

MIT
