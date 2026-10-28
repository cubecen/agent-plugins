Organization acme (you are an owner) is on the Free plan (cubes up to small); 1 of 3 cubes, no databases on this plan, 42 of 300 build minutes this period, 10.0 of 10 GB of bandwidth this period. Over its limits: bandwidth_gb. Its cubes are paused (bandwidth_limit)

{
  "slug": "acme",
  "name": "Acme",
  "role": "owner",
  "can": [
    "create_cubes",
    "deploy",
    "delete_cubes",
    "invite",
    "request_plan",
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
      "cubes": 1,
      "build_minutes": 42,
      "bandwidth_bytes": 10000000000
    },
    "over_limit": [
      "bandwidth_gb"
    ],
    "near_limit": [],
    "suspension": {
      "reason": "bandwidth_limit",
      "since": "2026-10-28T06:12:00Z",
      "until": "2026-11-01T00:00:00Z"
    }
  }
}
