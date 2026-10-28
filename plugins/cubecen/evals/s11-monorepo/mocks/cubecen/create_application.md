---
expect:
  name: string
  app_root: string
---

Created cube {{input.name}} from acme/shop through the organization's GitHub connection; its URL will be https://{{input.name}}-acme.cubecen.app. The first build started: call wait_for_release with application {{input.name}} and release bld_{{input.name}} until it is terminal

{
  "slug": "{{input.name}}",
  "runtime": {
    "app_root": "{{input.app_root}}"
  }
}
