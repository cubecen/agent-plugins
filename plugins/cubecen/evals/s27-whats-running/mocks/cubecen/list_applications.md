3 cubes
shop/web: active, https://shop-acme.cubecen.app, last release DEPLOYED 2 h ago (push by dev)
shop/api: active, https://api-acme.cubecen.app, last release DEPLOY_FAILED 20 min ago (push by dev): get_release with bld_14
shop/old: active, https://old-acme.cubecen.app, paused (admin), last release DEPLOYED 9 d ago (dashboard)

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
      },
      "last_release": {
        "build_id": "bld_14",
        "release_status": "DEPLOY_FAILED",
        "terminal": true
      }
    },
    {
      "slug": "old",
      "name": "old",
      "state": "active",
      "suspension": {
        "reason": "admin"
      },
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
        "public_url": "https://old-acme.cubecen.app",
        "app_root": "."
      }
    }
  ]
}
