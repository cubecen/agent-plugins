# DNS records at common providers

Most panels take the name relative to the domain: for `shop.example.com`
enter `shop`, and for the TXT record `_cubecen-challenge.shop`; `@` is the
apex. Leave the TTL at its default. Check from a terminal with
`dig +short TXT _cubecen-challenge.shop.example.com` and
`dig +short CNAME shop.example.com`.

| Provider | Where | Notes |
|---|---|---|
| Cloudflare | the domain, DNS, Records, Add record | the CNAME must be "DNS only" (grey cloud); the apex can be a CNAME (flattened) |
| Namecheap | Domain List, Manage, Advanced DNS, Add new record | apex: an `ALIAS` record to the target |
| GoDaddy | My Products, the domain, DNS, Add | no CNAME or ALIAS at the apex: use `www`, with forwarding from the apex |
| Amazon Route 53 | Hosted zones, the zone, Create record | CNAME for subdomains; the apex alias only reaches AWS resources: use `www` |
| Squarespace Domains (was Google Domains) | Domains, the domain, DNS, Custom records | no apex CNAME: use `www` |
| Porkbun | Domain management, DNS | apex: an `ALIAS` record |
| Hetzner DNS | the zone, Add record | no apex CNAME: use `www` |
| Vercel or Netlify DNS | the domain's DNS records | apex: an `ALIAS`/`ANAME` record |

If the provider has no way to point the apex, offer `www.example.com` for
the app and the provider's forwarding from `example.com` to it.
