---
name: devcontainer
description: Create or update .devcontainer/ — dev environment with Claude Code, GitHub CLI, and language toolchain. Use when starting a new project that needs a reproducible dev setup. Use when onboarding contributors and "works on my machine" is the main blocker. Use when the project adds a new service (Postgres, Redis) that every dev needs locally. Use when the existing devcontainer drifted from current toolchain versions.
metadata:
  version: "1.1"
  author: rodacato
  category: bootstrap
  triggers:
    - devcontainer
    - ".devcontainer"
    - "dev environment"
    - "dev container"
    - "VS Code container"
    - "reproducible dev setup"
    - "docker-compose dev"
---

# Devcontainer

## Overview

Create or update `.devcontainer/` so every contributor boots into the same
dev environment — Claude Code, GitHub CLI, language toolchain, and any
required services (Postgres, Redis). The environment is described in code
and rebuilt on demand; "works on my machine" is not an acceptable outcome.

## When to Use

- Brand new project that needs a reproducible dev setup from day one
- Onboarding friction is eating time — new devs can't get running in <30 min
- Project now requires a service (Postgres, Redis) that devs were installing locally
- Existing devcontainer is stale — base image, language version, or features are outdated
- Need to standardize tooling across a team using mixed host OSes

**When NOT to use:**
- Throwaway spike or single-author script with no collaborators
- Project already runs cleanly in a hosted environment and nobody codes locally
- User just wants a `Dockerfile` for production deploys — that is a different artifact

## Before you start

Inspect the current state and any identity/architecture docs the agent
should honor:

```bash
ls .devcontainer/ 2>/dev/null && echo "exists" || echo "not found"
fd ARCHITECTURE.md --exclude .git
fd CLAUDE.md --exclude .git
```

Required tools: none inside the skill itself — the human will need Docker
and the VS Code Dev Containers extension to actually use the result.

## Process

### If .devcontainer/ does NOT exist — Create

#### Step 1 — Determine language

Ask the human: "What's the primary language for this project?"

| Language | Feature to uncomment |
| --- | --- |
| Ruby | `"ghcr.io/devcontainers/features/ruby:1": { "version": "3.3" }` |
| Node.js | `"ghcr.io/devcontainers/features/node:1": { "version": "22" }` |
| Python | `"ghcr.io/devcontainers/features/python:1": { "version": "3.12" }` |
| Go | `"ghcr.io/devcontainers/features/go:1": { "version": "1.22" }` |
| Java | `"ghcr.io/devcontainers/features/java:1": { "version": "21" }` |
| Rust | `"ghcr.io/devcontainers/features/rust:1": { "version": "latest" }` |

See full list: https://containers.dev/features

#### Step 2 — Determine services

Ask: "Does this project need a database or cache?"
- PostgreSQL → uncomment `db` service in `docker-compose.yml`
- Redis → uncomment `redis` service in `docker-compose.yml`

Ask: "What port range should this project use? (e.g. 47000-47009)"
Update `docker-compose.yml` host ports accordingly.

#### Step 3 — Copy and customize

Fetch base files from the plugin:

```bash
BASE="https://raw.githubusercontent.com/rodacato/launchpad/master/skills/devcontainer"
mkdir -p .devcontainer
curl -sL "$BASE/devcontainer.json"    -o .devcontainer/devcontainer.json
curl -sL "$BASE/docker-compose.yml"   -o .devcontainer/docker-compose.yml
curl -sL "$BASE/Dockerfile"           -o .devcontainer/Dockerfile
curl -sL "$BASE/setup.sh"             -o .devcontainer/setup.sh
chmod +x .devcontainer/setup.sh
```

Then apply customizations:
1. In `devcontainer.json`: uncomment the chosen language feature
2. In `docker-compose.yml`: uncomment needed services, update port range
3. No changes needed to `Dockerfile` or `setup.sh` for most projects

Show the final `devcontainer.json` and `docker-compose.yml` to the human for approval.

#### Step 4 — Create .env.example

Based on the services enabled:

```bash
# If Postgres → add:
POSTGRES_USER=dev
POSTGRES_PASSWORD=dev
POSTGRES_DB=app_dev

# If Redis → add:
REDIS_URL=redis://redis:6379/0
```

#### Step 5 — Instructions to human

```
Devcontainer configured. Next steps:
1. Open this project in VS Code
2. Cmd+Shift+P → "Dev Containers: Rebuild and Reopen in Container"
3. Wait for the build to complete
4. Verify with: gh auth status && git --version && claude --version
```

### If .devcontainer/ already exists — Update

1. Read the current `devcontainer.json` and `docker-compose.yml`
2. Fetch the base template files from `skills/devcontainer/` in the plugin
3. Check for: new extensions, updated base image, new features
4. Ask the human which improvements to adopt
5. Apply changes, preserving project-specific customizations

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Everyone on the team runs the same OS — we don't need a container" | Today they do. The next hire, the CI runner, or a future contractor won't. The container is insurance written when it's cheap. |
| "Docker adds overhead, native is faster" | The overhead is five seconds on startup. The hours saved when a dep upgrade breaks one laptop dwarf it. |
| "I'll just document the setup in the README" | README drift is inevitable and unverifiable. A devcontainer is the README that actually runs. |
| "We don't need Postgres in the container, devs can install it" | Now every dev has a different Postgres version and half of them forgot to set a password. Services belong in compose. |
| "Port 5432 is fine, why pick a range?" | Because the next project will also want 5432, and now the dev can't run two projects at once. Ranges cost nothing and prevent collisions. |

## Red Flags

- `devcontainer.json` with no language feature uncommented — the container boots but has no toolchain
- `docker-compose.yml` exposes service ports to the host without a unique range (collides with other projects)
- Secrets hardcoded in `docker-compose.yml` or `devcontainer.json` instead of `.env`
- `setup.sh` not executable (`chmod +x` missed) — container build silently skips setup
- No `.env.example` committed — new dev boots and the app immediately crashes on missing env vars
- Language feature version pinned to `latest` on a project with a specific runtime requirement

## Verification

- [ ] `.devcontainer/devcontainer.json` exists and has exactly one language feature uncommented
- [ ] `.devcontainer/docker-compose.yml` exists with the chosen services enabled and a unique host port range
- [ ] `.devcontainer/Dockerfile` and `.devcontainer/setup.sh` are present; `setup.sh` is executable
- [ ] `.env.example` lists every variable the enabled services require
- [ ] No secrets (passwords, API keys) are committed — only placeholders in `.env.example`
- [ ] Human confirms "Rebuild and Reopen in Container" completes and `gh auth status && claude --version` succeed inside the container
- [ ] `.launchpad/manifest.yml` updated with `devcontainer: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `devcontainer: "1.1"` under `modules:`.

Next likely skills:
- `github` — wire up the repo settings, labels, and workflows the container expects
- `kamal` — define how the containerized app gets deployed to production
- `caddy` — front the local stack with a reverse proxy for HTTPS and routing
