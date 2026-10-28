Organization acme (you are an owner) is on the Launch plan (cubes up to large); 2 of 30 cubes, 0 of 3 databases, 120 of 1000 build minutes this period, 0.4 of 50 GB of bandwidth this period

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
      "id": "launch",
      "name": "Launch"
    },
    "limits": {
      "cubes": 30,
      "size": "large",
      "previews": 10,
      "build_minutes": 1000,
      "bandwidth_gb": 50,
      "databases": {
        "count": 3
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
        "available": true
      }
    ],
    "usage": {
      "cubes": 2,
      "databases": 0,
      "build_minutes": 120,
      "bandwidth_bytes": 400000000
    }
  }
}
