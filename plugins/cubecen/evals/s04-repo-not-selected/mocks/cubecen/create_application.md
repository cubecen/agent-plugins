---
error: true
---

REPOSITORY_NOT_CONNECTED: No GitHub connection of the organization covers acme/shop, so the cube would be made from its public link: pushes would not deploy it, only deploy calls
field: from_public_link
next: if the user owns or pushes to this repository (it is the repository they work in), ask whether to connect it so every push deploys: acme's GitHub connection covers selected repositories only: the user adds acme/shop to it on the dashboard's integrations page: call connect_github and give the user its link, and when they say it is done call create_application again. If it is someone else's public repository, or the user wants the public link, call create_application again with from_public_link true
