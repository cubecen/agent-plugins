---
expect:
  repository: /acme.shop/
---

Created cube shop from acme/shop through the organization's GitHub connection; its URL will be https://shop-acme.cubecen.app. The first build started: call wait_for_release with application shop and release bld_1 until it is terminal

{
  "slug": "shop",
  "state": "active",
  "runtime": {
    "public_url": "https://shop-acme.cubecen.app"
  },
  "build": {
    "id": "bld_1"
  }
}
