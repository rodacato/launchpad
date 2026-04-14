---
name: kamal
description: Create or update config/deploy.yml — Kamal deployment configuration
metadata:
  version: "1.0"
  author: rodacato
  triggers:
    - kamal
    - "deploy.yml"
    - "kamal deploy"
    - deployment
---

# Kamal

Create or update `config/deploy.yml` — Kamal deployment configuration.

## Before you start

```bash
ls config/deploy.yml 2>/dev/null && echo "exists" || echo "not found"
find . -name "ARCHITECTURE.md" -not -path "*/.git/*"
find . -name "CLAUDE.md" -not -path "*/.git/*"
```

---

## If config/deploy.yml does NOT exist — Create

### Step 1 — Gather deployment info
Ask:
- "What's the app name? (used for container names)"
- "What's the server IP or hostname?"
- "What registry are you using? (Docker Hub, GHCR, etc.)"
- "Does the app need a database? (Kamal accessory for Postgres/MySQL)"
- "What env vars does the app need? (will go in .kamal/secrets)"

### Step 2 — Create deploy.yml
Structure:
```yaml
service: {app-name}
image: {registry}/{image}
servers:
  - {server-ip}
registry:
  server: {registry}
  username:
    - KAMAL_REGISTRY_USERNAME
  password:
    - KAMAL_REGISTRY_PASSWORD
env:
  secret:
    - DATABASE_URL
    - SECRET_KEY_BASE
```

### Step 3 — Create .kamal/secrets
Show the human what secrets to add. Never commit actual values.

### Step 4 — First deploy checklist
- [ ] Server has Docker installed
- [ ] SSH key configured
- [ ] Registry credentials in `.kamal/secrets`
- [ ] Run: `kamal setup`

---

## If config/deploy.yml already exists — Update

1. Read the current file
2. Ask what needs to change (new server, new env vars, new accessory)
3. Update with approved changes

---

## When done

Update `.launchpad/manifest.yml` — set `kamal: "1.0"` under `modules:`.
