---
name: kamal
description: Create or update config/deploy.yml — Kamal deployment configuration for container-based deploys to your own servers. Use when deploying a Dockerized app to a VPS without a PaaS. Use when migrating off Heroku/Render onto owned infrastructure. Use when adding a new server, registry, or accessory (Postgres, Redis) to an existing Kamal setup. Use when setting up zero-downtime rolling deploys.
metadata:
  version: "1.1"
---

# Kamal

## Overview

Create or update `config/deploy.yml` — Kamal deployment config for
container-based deploys onto your own servers. Kamal handles image
build, push, rolling restart, and health-checked cutover so you get
zero-downtime deploys without Kubernetes or a PaaS bill.

## When to Use

- App is Dockerized and needs to run on one or more VPS boxes you control
- Migrating off Heroku, Render, or similar PaaS onto owned infrastructure
- Adding a new server, registry, or accessory (Postgres, Redis) to an existing deploy
- Team wants `kamal deploy` as the single "ship it" command, replacing ad-hoc ssh + docker run
- First-time production deploy for a project that already runs in a devcontainer

**When NOT to use:**
- App is static and a CDN + object storage suffices — Kamal is overkill
- Platform-managed deploys already work (Fly, Railway, Render) and the team isn't leaving
- App is not yet containerized — containerize first, then return to this skill

## Before you start

Inspect the current state and architecture docs:

```bash
ls config/deploy.yml 2>/dev/null && echo "exists" || echo "not found"
fd ARCHITECTURE.md --exclude .git
fd CLAUDE.md --exclude .git
```

Required tools on the operator's machine: `kamal` CLI, `docker`, an SSH
key that can reach the target servers, and credentials for the chosen
container registry.

## Process

### If config/deploy.yml does NOT exist — Create

#### Step 1 — Gather deployment info

Ask:
- "What's the app name? (used for container names)"
- "What's the server IP or hostname?"
- "What registry are you using? (Docker Hub, GHCR, etc.)"
- "Does the app need a database? (Kamal accessory for Postgres/MySQL)"
- "What env vars does the app need? (will go in .kamal/secrets)"

#### Step 2 — Create deploy.yml

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

#### Step 3 — Create .kamal/secrets

Show the human which secrets to add. Never commit actual values.
`.kamal/secrets` MUST be in `.gitignore`; `.kamal/secrets.example` may
be committed with placeholder keys only.

#### Step 4 — First deploy checklist

- [ ] Server has Docker installed
- [ ] SSH key configured
- [ ] Registry credentials in `.kamal/secrets`
- [ ] Run: `kamal setup`

### If config/deploy.yml already exists — Update

1. Read the current file
2. Ask what needs to change (new server, new env vars, new accessory)
3. Update with approved changes, preserving existing structure

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll just ssh in and `docker run` for now" | That's how you get a box nobody remembers how to redeploy. Kamal makes the deploy reproducible from day one. |
| "Secrets can live in `deploy.yml`, the repo is private" | Private today, forked/leaked/public tomorrow. `deploy.yml` is committed; `.kamal/secrets` is not — keep the line sharp. |
| "We don't need a health check, the app boots fast" | Without a health check Kamal cuts over to a container that may still be loading, and users see 502s. It's one line of config. |
| "One server is fine, we'll worry about HA later" | Fine — but write it as a list `servers:` now, so adding a second box later is one-line diff, not a config rewrite. |
| "I'll skip the registry and build on the server" | Now every deploy rebuilds from scratch, and rollback means rebuilding the old commit. Registry-based flow is non-negotiable. |

## Red Flags

- `.kamal/secrets` is NOT in `.gitignore` — real credentials are one `git add` away from being public
- `env.secret` lists keys that don't exist in `.kamal/secrets` — deploy will succeed but the app will crash on startup
- `servers:` contains a hostname that doesn't resolve or an IP the SSH key can't reach
- Registry credentials in `deploy.yml` as literals instead of env var references
- No `healthcheck` defined — rolling deploy has no signal for "new container is ready"
- `image:` points to a registry namespace the operator can't push to — `kamal deploy` fails on push

## Verification

- [ ] `config/deploy.yml` exists with `service`, `image`, `servers`, `registry`, `env` filled in
- [ ] `.kamal/secrets` exists locally AND is listed in `.gitignore`
- [ ] `.kamal/secrets.example` (or documented equivalent) committed with placeholder keys
- [ ] Every key in `env.secret` is defined in `.kamal/secrets`
- [ ] `kamal config` exits 0 (config is syntactically valid and references resolve)
- [ ] First-deploy checklist items confirmed with the human before running `kamal setup`
- [ ] `.launchpad/manifest.yml` updated with `kamal: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `kamal: "1.1"` under `modules:`.

Next likely skills:
- `caddy` — add a reverse proxy in front of the deployed containers
- `github` — wire up a workflow that calls `kamal deploy` on tag/release
- `devcontainer` — keep dev and prod images aligned so "works on my machine" maps to "works on server"
