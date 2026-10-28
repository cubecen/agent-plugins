---
name: domain
description: Use when the user wants a custom domain or their own domain name for a Cubecen app, asks about DNS records, CNAME, TXT, apex or www for Cubecen, or a domain on Cubecen is not active, not verified or has no certificate.
---

# A custom domain on Cubecen

## 1. Add it

`add_domain` with the hostname (`shop.example.com`); up to 10 per cube.
The answer lists the DNS records to create:

- **ownership**: a `TXT` record `_cubecen-challenge.<hostname>` holding
  `cubecen-verify=<token>`;
- **routing**: a `CNAME` from the hostname to the target in the answer
  (`customers.cubecen.com` today): always take it from the answer.

An apex domain (`example.com`, `apex: true`) cannot have a plain CNAME:
the provider's CNAME flattening or ALIAS record (Cloudflare flattens by
itself), or `www.example.com` instead.

## 2. The records at the user's DNS provider

Give both records as a table (type, name, value) and the steps for their
provider from `references/registrars.md`. At Cloudflare the CNAME is
"DNS only" (grey cloud).

## 3. Check it

When the user says the records are in place, `check_domain`; repeat
`list_domains` or `check_domain` while it moves on. DNS can take minutes
to hours to be visible.

| Status | Meaning |
|---|---|
| `pending_verification` | waiting for the TXT record |
| `provisioning` | verified; waiting for the CNAME, the certificate and the route |
| `active` | served over HTTPS at `https://<hostname>` |
| `failed` | `error` says why; `check_domain` starts it over |

| Error | Fix |
|---|---|
| `DNS_NOT_VERIFIED` | the TXT record was not found for seven days |
| `DNS_NOT_POINTED` | the CNAME is missing or points elsewhere |
| `CERTIFICATE_PENDING` | wait; a `CAA` record must allow Cloudflare's certificate authorities |
| `DOMAIN_TAKEN` | another cube proved the hostname first |
| `ROUTING_PENDING` | wait a minute, or deploy the cube once |

## Rules

- `remove_domain` stops serving the hostname: confirm first.
- The `cubecen.app` URL keeps working; there are no redirects between the
  two.
