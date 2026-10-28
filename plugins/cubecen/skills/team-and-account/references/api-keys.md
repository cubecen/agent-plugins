# Storing a Cubecen API key

The key acts as the person who made it, in one organization: `read` keys
read, `full` keys also deploy and change cubes. It stops working at its
expiry or when revoked. Its value is in the conversation already; keep it out
of everything else: replies, files under git, URLs, issues, comments.

## Check the destination first

- GitHub Actions: `gh auth status` succeeds and the repository is on
  GitHub. Otherwise the user stores it through the repository's Settings →
  Secrets and variables → Actions, so make no key here: send them to the
  dashboard's API keys page to make one and paste it there themselves.
- A local `.env`: `git check-ignore -q .env` succeeds and
  `git ls-files --error-unmatch .env` fails (ignored and not tracked).

## GitHub Actions

Write the value with the Write tool to a file outside the repository, read
it from there, and delete it, so the value is in no command line:

```sh
gh secret set CUBECEN_API_KEY < "$file" && rm -f "$file"
```

Name the secret as the workflow reads it (often `CUBECEN_API_KEY`); the
workflow sends `Authorization: Bearer ${{ secrets.CUBECEN_API_KEY }}`.

## GitLab CI

A masked CI/CD variable, set by the user in Settings → CI/CD → Variables
(a protected variable reaches protected branches only).

## Rotating

Make the new key, switch what uses it, then revoke the old one.
