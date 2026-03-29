# Module: devcontainer

## What this installs

`.devcontainer/` — Dev environment with Claude Code, GitHub CLI, and language toolchain.
Contains: `devcontainer.json`, `docker-compose.yml`, `Dockerfile`, `setup.sh`.

Based on VS Code Dev Containers. See: https://containers.dev/features

## Before you start

Check if `.devcontainer/` already exists:

```bash
ls .devcontainer/ 2>/dev/null && echo "exists" || echo "not found"
```

Also check the stack:

```bash
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

Copy the base files from the module:

```bash
mkdir -p .devcontainer
# Files to copy from: modules/infra/devcontainer/
# devcontainer.json, docker-compose.yml, Dockerfile, setup.sh
```

Then apply customizations:
1. In `devcontainer.json`: uncomment the chosen language feature (add trailing comma to previous entry)
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

# Project-specific vars:
# APP_PORT=3000
# SECRET_KEY=
```

### Step 5 — Instructions to human

Tell the human:
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
2. Compare with the base template files in `modules/infra/devcontainer/`
3. Check for: new extensions, updated base image, new features
4. Ask the human which improvements to adopt
5. Apply changes, preserving project-specific customizations

---

## When done

Update `.launchpad/manifest.yml`:
- Add `devcontainer: "1.0"` under `modules:`

Then delete `LAUNCHPAD_TASK.md`.
