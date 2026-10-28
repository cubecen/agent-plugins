1 cube
shop/web: active, https://shop-acme.cubecen.app, last release DEPLOY_FAILED 5 min ago (push by dev): get_release with bld_3

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
      },
      "last_release": {
        "build_id": "bld_3",
        "release_status": "DEPLOY_FAILED",
        "terminal": true
      }
    }
  ]
}
