---
name: caddy
description: Create or update Caddyfile — reverse proxy configuration with automatic HTTPS. Use when the project needs HTTPS without wrestling with cert renewal. Use when an app server sits behind a domain and needs a front door. Use when static assets and a dynamic app share the same hostname. Use when adding a second domain or subdomain to an existing Caddy setup.
metadata:
  version: "1.1"
  author: rodacato
  category: bootstrap
  triggers:
    - caddy
    - Caddyfile
    - "reverse proxy"
    - "https setup"
    - "tls certificate"
    - "let's encrypt"
    - "static files serve"
---

# Caddy

## Overview

Create or update `Caddyfile` — Caddy reverse proxy configuration. Caddy
handles HTTPS automatically (Let's Encrypt in production, self-signed in
dev), proxies inbound requests to your app, and optionally serves static
files directly. One config file replaces nginx + certbot + a cron job.

## When to Use

- Project needs HTTPS on a real domain and you don't want to own cert renewal
- App listens on an internal port and needs a public-facing front door
- Mixing static assets (docs, uploads, SPA build) with a dynamic backend on the same host
- Local dev stack wants HTTPS-on-localhost to mirror production behavior
- Adding a new domain, subdomain, or route to an existing Caddy deployment

**When NOT to use:**
- App is already fronted by a managed platform (Vercel, Fly, Railway) that terminates TLS
- Purely internal tool with no TLS needs — a plain `docker-compose` port mapping is enough
- Nginx or Traefik is already in place and working — don't swap load balancers mid-project

## Before you start

Inspect the current state:

```bash
ls Caddyfile 2>/dev/null && echo "exists" || echo "not found"
fd ARCHITECTURE.md --exclude .git
```

Know before you ask: what port the app listens on, what domain(s) are
pointed at the server, and whether the box has ports 80/443 free for
Caddy to claim.

## Process

### If Caddyfile does NOT exist — Create

#### Step 1 — Gather info

Ask:
- "What domain(s) will this serve?"
- "What port is the app running on?"
- "Do you need to serve any static files directly? (docs, uploads)"
- "Is this for production (real domain + HTTPS) or local dev?"

#### Step 2 — Create Caddyfile

For production:
```
{domain} {
    reverse_proxy localhost:{port}
}
```

For local dev:
```
localhost:{caddy-port} {
    reverse_proxy localhost:{app-port}
    tls internal
}
```

With static files:
```
{domain} {
    handle /static/* {
        root * /srv/public
        file_server
    }
    reverse_proxy localhost:{port}
}
```

#### Step 3 — Show final config for approval

Present the Caddyfile to the human. Confirm:
- the domain resolves to this server (for production)
- the app port matches what the app actually listens on
- any static path on disk actually exists

### If Caddyfile already exists — Update

1. Read the current file
2. Ask what needs to change (new domain, new route, new static path)
3. Update with approved changes, preserving existing blocks

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "We can just use nginx, I already know it" | nginx + certbot + renewal cron is three moving parts. Caddy is one. Familiarity is not a reason to ship more ops surface. |
| "TLS is optional for a prototype" | Browsers, OAuth providers, and cookies disagree. `SameSite=None; Secure` requires HTTPS even on localhost. Start with TLS, not as a retrofit. |
| "`tls internal` in dev is a hassle" | Running `caddy trust` once installs the local CA. After that, HTTPS-on-localhost is indistinguishable from production. |
| "One big Caddyfile block is simpler" | Until you need to tweak one route and reload breaks all of them. Named `handle` blocks scope changes. |
| "I'll hardcode the upstream port, it never changes" | Until the app moves to a container and the port is now an env var. Use a variable or document the coupling. |

## Red Flags

- Caddyfile references a domain whose DNS does not yet point to this host — Caddy will log cert failures every minute
- App port in `reverse_proxy` does not match the app's actual listening port — 502 Bad Gateway on every request
- Static `root` path does not exist on disk — silent 404s with no obvious cause
- Production block omits `tls internal` AND runs on localhost — Caddy will try to provision a public cert for `localhost` and fail
- Multiple site blocks for the same domain — last one silently wins, earlier ones ignored
- Ports 80/443 not free on the host (nginx, Apache still running) — Caddy fails to bind and exits

## Verification

- [ ] `Caddyfile` exists at the project root (or documented alternate path)
- [ ] Every site block names a real domain or explicit `localhost:PORT`
- [ ] Every `reverse_proxy` target matches a port the app actually listens on
- [ ] Dev blocks use `tls internal`; production blocks do NOT
- [ ] Any `root` directive points to a directory that exists
- [ ] `caddy validate --config Caddyfile` exits 0
- [ ] `.launchpad/manifest.yml` updated with `caddy: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `caddy: "1.1"` under `modules:`.

Next likely skills:
- `kamal` — wire Caddy into the deploy pipeline as an accessory
- `devcontainer` — expose the Caddy port range in the dev compose file
- `github` — add a workflow that validates the Caddyfile on PR
