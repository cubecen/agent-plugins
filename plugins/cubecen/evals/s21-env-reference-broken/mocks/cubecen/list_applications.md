2 cubes
shop/web: active, https://shop-acme.cubecen.app, last release DEPLOYED 1 d ago (push by dev)
shop/api: active, https://api-acme.cubecen.app, last release DEPLOYED 1 d ago (push by dev)

{
  "items": [
    {
      "slug": "web",
      "name": "web",
      "state": "active",
      "project": {
        "slug": "shop"
      },
      "repository": {
        "owner": "acme",
        "name": "shop",
        "url": "https://github.com/acme/shop.git",
        "default_branch": "main"
      },
      "runtime": {
        "public_url": "https://shop-acme.cubecen.app",
        "app_root": "."
      }
    },
    {
      "slug": "api",
      "name": "api",
      "state": "active",
      "project": {
        "slug": "shop"
      },
      "repository": {
        "owner": "acme",
        "name": "shop",
        "url": "https://github.com/acme/shop.git",
        "default_branch": "main"
      },
      "runtime": {
        "public_url": "https://api-acme.cubecen.app",
        "app_root": "."
      }
    }
  ]
}
