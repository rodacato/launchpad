---
name: devcontainer
description: Create or update .devcontainer/ — dev environment with Claude Code, GitHub CLI, and language toolchain
metadata:
  version: "1.0"
  author: rodacato
  triggers:
    - devcontainer
    - ".devcontainer"
    - "dev environment"
    - "dev container"
---

# Devcontainer

Create or update `.devcontainer/` — dev environment with Claude Code, GitHub CLI, and
language toolchain. Based on VS Code Dev Containers.

## Before you start

```bash
ls .devcontainer/ 2>/dev/null && echo "exists" || echo "not found"
find . -name "ARCHITECTURE.md" -not -path "*/.git/*"
find . -name "CLAUDE.md" -not -path "*/.git/*"
```

---

## If .devcontainer/ does NOT exist — Create

### Step 1 — Determine language

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

### Step 2 — Determine services

Ask: "Does this project need a database or cache?"
- PostgreSQL → uncomment `db` service in `docker-compose.yml`
- Redis → uncomment `redis` service in `docker-compose.yml`

Ask: "What port range should this project use? (e.g. 47000-47009)"
Update `docker-compose.yml` host ports accordingly.

### Step 3 — Copy and customize

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

### Step 4 — Create .env.example

Based on the services enabled:

```bash
# If Postgres → add:
POSTGRES_USER=dev
POSTGRES_PASSWORD=dev
POSTGRES_DB=app_dev

# If Redis → add:
REDIS_URL=redis://redis:6379/0
```

### Step 5 — Instructions to human

```
Devcontainer configured. Next steps:
1. Open this project in VS Code
2. Cmd+Shift+P → "Dev Containers: Rebuild and Reopen in Container"
3. Wait for the build to complete
4. Verify with: gh auth status && git --version && claude --version
```

---

## If .devcontainer/ already exists — Update

1. Read the current `devcontainer.json` and `docker-compose.yml`
2. Fetch the base template files from `skills/devcontainer/` in the plugin
3. Check for: new extensions, updated base image, new features
4. Ask the human which improvements to adopt
5. Apply changes, preserving project-specific customizations

---

## When done

Update `.launchpad/manifest.yml` — set `devcontainer: "1.0"` under `modules:`.
