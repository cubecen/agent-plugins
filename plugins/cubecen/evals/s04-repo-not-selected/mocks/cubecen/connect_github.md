Give the user this link to connect GitHub: https://app.cubecen.com/o/acme/integrations?connect=github&from=mcp . They click Connect GitHub there, then pick the GitHub account and the repositories Cubecen may use; only an owner of the organization can (anyone else forwards the link to one). When they say it is done, call list_github_repositories. Already connected: acme (selected repositories); the same page connects another account, and GitHub's settings for the Cubecen app give a connection more repositories

{
  "link": "https://app.cubecen.com/o/acme/integrations?connect=github&from=mcp",
  "installations": [
    {
      "account_login": "acme",
      "repository_selection": "selected"
    }
  ]
}
