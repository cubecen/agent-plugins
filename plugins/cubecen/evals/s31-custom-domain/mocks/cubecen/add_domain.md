---
expect:
  hostname: shop.example.com
---

Added shop.example.com; create its DNS records, then check_domain

{
  "hostname": "shop.example.com",
  "apex": false,
  "status": "pending_verification",
  "dns_records": [
    {
      "purpose": "ownership",
      "type": "TXT",
      "name": "_cubecen-challenge.shop.example.com",
      "value": "cubecen-verify=3f1c9a7e5b2d4c6f8a0b1c2d3e4f5a6b",
      "ok": null
    },
    {
      "purpose": "routing",
      "type": "CNAME",
      "name": "shop.example.com",
      "value": "customers.cubecen.com",
      "ok": null
    }
  ]
}
