# GitHub connection or public link

Cubecen deploys every push only for a repository a GitHub connection of the
organization covers. A cube made from a public repository's link deploys
only when `deploy` is called.

## `REPOSITORY_NOT_CONNECTED`

`create_application` found no connection covering the repository and made
nothing. Decide with the user, never alone.

**The user's own repository**: it is the repository they work in (`origin`),
or they push to it (`gh repo view owner/name --json viewerPermission`
answers `ADMIN`, `MAINTAIN` or `WRITE`).

1. When `next:` says the owner's connection covers selected repositories
   only, the user already connected GitHub: do not ask. Call
   `connect_github` and give its link in your message; that page is where
   they add this repository to the connection. Go to step 3.
2. Otherwise ask in one sentence: "Connect GitHub so every push deploys this
   app?" Yes: call `connect_github` and give the user its link, in your
   message.
3. Wait until they say it is done, then call `create_application` again
   with the same arguments.
4. No: use the public link, as below.

**Someone else's public repository** (an example, a template), or the user
chose the public link: call `create_application` again with
`from_public_link: true`. Tell the user pushes will not deploy it: `deploy`
after each push.

## `REPOSITORY_NOT_ACCESSIBLE`

After `from_public_link`: the repository is private or does not exist. A
private one needs GitHub connected: `connect_github`, its link to the user,
wait until they say it is done, then create again without
`from_public_link`.

## A cube that exists from a public link

`get_application` says so. Pushes do not deploy it: call `deploy` after a
push. Tell the user once that connecting GitHub, deleting the cube and
making it again would deploy every push; its URL changes, so do it only
with their yes, and confirm the deletion first.
