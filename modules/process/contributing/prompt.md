# Module: contributing

## What this installs

`CONTRIBUTING.md` — Contribution guidelines. How to set up the dev environment,
branch naming, commit conventions, how to open a PR, code style, and testing expectations.
Customized to this project's stack and workflow.

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
- "Is this open source or internal? (affects tone of CONTRIBUTING.md)"
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

Use the template at `modules/process/contributing/template.md` as base.

---

## If CONTRIBUTING.md already exists — Update

1. Read the current file
2. Check for missing sections or outdated commands
3. Update with approved changes, preserving project-specific content

---

## When done

Update `.launchpad/manifest.yml`:
- Add `contributing: "1.0"` under `modules:`

Then delete `LAUNCHPAD_TASK.md`.
