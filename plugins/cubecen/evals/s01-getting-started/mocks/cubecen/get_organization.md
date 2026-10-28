Organization acme (you are an owner) is on the Free plan (cubes up to small); 0 of 3 cubes, no databases on this plan, 0 of 300 build minutes this period, 0.0 of 10 GB of bandwidth this period

{
  "slug": "acme",
  "role": "owner",
  "can": [
    "create_cubes",
    "deploy",
    "delete_cubes"
  ],
  "links": {
    "plan": "https://app.cubecen.com/o/acme/settings/billing?from=mcp",
    "members": "https://app.cubecen.com/o/acme/members?from=mcp",
    "usage": "https://app.cubecen.com/o/acme/usage?from=mcp",
    "integrations": "https://app.cubecen.com/o/acme/integrations?from=mcp"
  },
  "plan": {
    "plan": {
      "id": "free",
      "name": "Free"
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
    "sizes": [
      {
        "size": "small",
        "memory_mib": 2048,
        "available": true
      },
      {
        "size": "medium",
        "memory_mib": 4096,
        "available": false
      }
    ],
    "usage": {
      "cubes": 0,
      "databases": 0,
      "build_minutes": 0,
      "bandwidth_bytes": 0
    }
  }
}
