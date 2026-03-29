# Module: agents

## What this installs

`AGENTS.md` — Agent roles, responsibilities, startup behavior, triggers, and
project-specific rules. This is what defines HOW the agent works in this project.
Lives at the repo root so it's always visible.

Optionally also configures `CLAUDE.md` if it needs updating.

## Before you start

Search for these files:
- `CLAUDE.md` — project identity, conventions, what NOT to do
- `WORKFLOW.md` — so agent startup behavior references the right files

Use: `find . -name "CLAUDE.md" -not -path "*/.git/*"`

---

## If AGENTS.md does NOT exist — Create

### Step 1 — Review the project
Read CLAUDE.md for project identity and stack context.
Find and read the WORKFLOW.md if it exists.

### Step 2 — Discuss the agent roster
Ask the human:
- "What agents do you use? Just Claude Code locally, or also remote agents?"
- "Are there any tasks the agent should NEVER do without human approval?"
- "Are there recurring triggers you want the agent to handle automatically?"
  (e.g. "when I say 'deploy', follow the deployment playbook")

### Step 3 — Configure startup behavior
The standard startup behavior for Team Lead:
1. Read CLAUDE.md for project context
2. Read docs/WORKFLOW.md for process
3. Read AGENTS.md for project-specific rules
4. Check for module updates: run check.sh or check .launchpad/manifest.yml against remote versions
5. Check current sprint health (open milestone with 0 open issues → suggest sprint planning)
6. List assigned issues → self-assign if empty

Ask: "Is there anything you want added or changed in the startup sequence?"

### Step 4 — Project-specific rules and triggers
Ask:
- "Are there modules or parts of the codebase where you want extra caution?"
  (e.g. "don't touch billing without human approval")
- "What commands should the agent never run? What always needs confirmation?"

Use the template at `modules/agents/template.md` as structure.
Show the result to the human for approval.

---

## If AGENTS.md already exists — Update

1. Find the file: `find . -name "AGENTS.md" -not -path "*/.git/*" -maxdepth 2`
2. Read the current content
3. Check the template for improvements:
   `https://raw.githubusercontent.com/rodacato/launchpad/master/modules/agents/template.md`
4. Common improvements: startup behavior referencing old file paths, missing triggers,
   outdated check mechanism (old sync.sh references → new check.sh)
5. Update with approved changes, preserving project-specific rules

---

## When done

Update `.launchpad/manifest.yml`:
- Add `agents: "1.0"` under `modules:`

Then delete `LAUNCHPAD_TASK.md`.
