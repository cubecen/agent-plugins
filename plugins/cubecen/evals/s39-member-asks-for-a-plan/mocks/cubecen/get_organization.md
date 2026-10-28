Organization acme (you are a member) is on the Free plan (cubes up to small); 2 of 3 cubes, no databases on this plan, 80 of 300 build minutes this period, 0.6 of 10 GB of bandwidth this period

{
  "slug": "acme",
  "name": "Acme",
  "role": "member",
  "can": [
    "create_cubes",
    "deploy",
    "api_keys"
  ],
  "links": {
    "plan": "https://app.cubecen.com/o/acme/settings/billing?from=mcp",
    "members": "https://app.cubecen.com/o/acme/members?from=mcp",
    "invitations": "https://app.cubecen.com/o/acme/members?tab=invitations&from=mcp",
    "invite_form": "https://app.cubecen.com/o/acme/members?tab=invitations&invite=1&from=mcp",
    "api_keys": "https://app.cubecen.com/o/acme/settings/api-keys?from=mcp",
    "usage": "https://app.cubecen.com/o/acme/usage?from=mcp",
    "integrations": "https://app.cubecen.com/o/acme/integrations?from=mcp",
    "settings": "https://app.cubecen.com/o/acme/settings?from=mcp"
  },
  "plan": {
    "plan": {
      "id": "free",
      "name": "Free",
      "period_start": "2026-10-01T00:00:00Z",
      "period_end": "2026-11-01T00:00:00Z"
    },
    "limits": {
      "cubes": 3,
      "size": "small",
      "previews": 0,
      "build_minutes": 300,
      "bandwidth_gb": 10,
      "databases": {
        "count": 0
      }
    },
    "usage": {
      "cubes": 2,
      "build_minutes": 80,
      "bandwidth_bytes": 600000000
    },
    "over_limit": [],
    "near_limit": [],
    "suspension": null
  }
}
