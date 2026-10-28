# Storing a Cubecen API key

The key acts as the person who made it, in one organization: `read` keys
read, `full` keys also deploy and change cubes. It stops working at its
expiry or when revoked.

## GitHub Actions

Store it as a repository secret named as the workflow reads it (often
`CUBECEN_API_KEY`). With the GitHub CLI, from the repository's directory,
the value goes in on stdin, never as an argument:

```sh
gh secret set CUBECEN_API_KEY <<'EOF_KEY'
<the value>
EOF_KEY
```

When you cannot run it (no `gh`, or it is not signed in), tell the user to
open the repository's Settings → Secrets and variables → Actions → New
repository secret, and to paste the value they keep from this conversation,
or make a new key there themselves in the dashboard (`links.api_keys`).

The workflow then sends `Authorization: Bearer ${{ secrets.CUBECEN_API_KEY }}`.

## GitLab CI

A CI/CD variable, masked and protected: Settings → CI/CD → Variables.

## A local script

An `.env` file that git ignores: check `.gitignore` lists it before
writing; never commit it.

## Rotating

Make the new key, switch what uses it, then revoke the old one.
