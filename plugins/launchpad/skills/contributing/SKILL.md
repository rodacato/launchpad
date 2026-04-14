---
name: contributing
description: Create or update CONTRIBUTING.md — dev setup, branch conventions, PR process, testing expectations
metadata:
  version: "1.0"
  author: rodacato
  triggers:
    - contributing
    - "CONTRIBUTING.md"
    - "contribution guidelines"
    - "how to contribute"
---

# Contributing

Create or update `CONTRIBUTING.md` — contribution guidelines. Dev environment setup,
branch naming, commit conventions, how to open a PR, code style, and testing expectations.

## Before you start

Search for these files (they contain most of the info needed):
- `AGENTS.md` — has the workflow conventions
- `WORKFLOW.md` — has test commands, definition of done

```bash
find . -name "AGENTS.md" -not -path "*/.git/*"
find . -name "WORKFLOW.md" -not -path "*/.git/*" -not -path "*/.launchpad/*"
```

---

## If CONTRIBUTING.md does NOT exist — Create

### Step 1 — Gather project info
From the files above, extract:
- Dev environment setup (devcontainer or local?)
- Branch naming convention
- Commit type convention
- Test command(s)
- Lint/typecheck commands
- PR requirements (closes #N, etc.)

### Step 2 — Ask the human
- "Is this open source or internal? (affects tone)"
- "Do contributors need to sign a CLA or DCO?"
- "Is there anything non-obvious about contributing to this project?"

### Step 3 — Create CONTRIBUTING.md
Structure:
1. Prerequisites (tools, accounts)
2. Dev environment setup
3. Running tests
4. Branch and commit conventions
5. Opening a PR
6. Code review process
7. Reporting issues

---

## If CONTRIBUTING.md already exists — Update

1. Read the current file
2. Check for missing sections or outdated commands
3. Update with approved changes, preserving project-specific content

---

## When done

Update `.launchpad/manifest.yml` — set `contributing: "1.0"` under `modules:`.
