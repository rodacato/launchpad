---
name: caddy
description: Create or update Caddyfile — reverse proxy configuration
metadata:
  version: "1.0"
  author: rodacato
  triggers:
    - caddy
    - Caddyfile
    - "reverse proxy"
    - "https setup"
---

# Caddy

Create or update `Caddyfile` — Caddy reverse proxy configuration. Handles HTTPS
automatically, proxies to your app, and optionally serves static files.

## Before you start

```bash
ls Caddyfile 2>/dev/null && echo "exists" || echo "not found"
find . -name "ARCHITECTURE.md" -not -path "*/.git/*"
```

---

## If Caddyfile does NOT exist — Create

### Step 1 — Gather info
Ask:
- "What domain(s) will this serve?"
- "What port is the app running on?"
- "Do you need to serve any static files directly? (docs, uploads)"
- "Is this for production (real domain + HTTPS) or local dev?"

### Step 2 — Create Caddyfile

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

### Step 3 — Show final config for approval

---

## If Caddyfile already exists — Update

1. Read the current file
2. Ask what needs to change (new domain, new route, new static path)
3. Update with approved changes

---

## When done

Update `.launchpad/manifest.yml` — set `caddy: "1.0"` under `modules:`.
