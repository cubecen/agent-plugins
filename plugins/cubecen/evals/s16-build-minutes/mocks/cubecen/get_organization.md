Organization acme (you are an owner) is on the Free plan (cubes up to large); 1 of 3 cubes, 0 of 3 databases, 300 of 300 build minutes this period, 0.4 of 50 GB of bandwidth this period. Over its limits: build_minutes

{
  "slug": "acme",
  "name": "Acme",
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
      "build_minutes": 300,
      "bandwidth_gb": 50,
      "size": "large"
    },
    "usage": {
      "cubes": 1,
      "build_minutes": 300
    },
    "over_limit": [
      "build_minutes"
    ]
  }
}
