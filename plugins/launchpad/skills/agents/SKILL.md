---
name: agents
description: Create or update AGENTS.md — agent roles, startup behavior, triggers, and project-specific rules the agent must follow. Use when a project uses Claude Code or other agents and they lack a startup contract. Use when the agent keeps asking the same context questions every session. Use when there are modules the agent should never touch without approval. Use when recurring triggers ("when I say deploy, follow the playbook") need to be codified.
metadata:
  version: "1.1"
---

# Agents

## Overview

Create or update `AGENTS.md` — the written contract for HOW agents (Claude Code, remote agents, sub-agents) work in this project. Roles, startup behavior, triggers, and project-specific safety rules live here. Without this document, every agent session starts blind and reinvents the process.

## When to Use

- Project uses Claude Code or other AI agents and there's no written startup contract
- Agent keeps asking the same context questions every session ("what's the stack?", "where do tests live?")
- There are modules or paths the agent should NEVER modify without human approval (billing, auth, production configs)
- Recurring natural-language triggers need to be formalized ("when I say 'deploy', follow the deployment playbook")
- AGENTS.md exists but references stale file paths or conventions that have since moved

**When NOT to use:**
- Project does not use agents at all — no need for a contract with nobody
- CLAUDE.md and WORKFLOW.md are missing — agents.md should build on those, not precede them
- As a substitute for inline agent instructions in CLAUDE.md for simple preferences

## Before you start

Search for these files:
- `CLAUDE.md` — project identity, conventions, what NOT to do
- `WORKFLOW.md` — so agent startup behavior references the right files

Use: `fd CLAUDE.md --exclude .git` (or `find . -name "CLAUDE.md" -not -path "*/.git/*"`)

If CLAUDE.md is missing, create or run its skill first. AGENTS.md layers on top of CLAUDE.md — without it there's nothing to layer on.

## Process

### If AGENTS.md does NOT exist — Create

#### Step 1 — Review the project
Read CLAUDE.md for project identity and stack context.
Find and read WORKFLOW.md if it exists.

#### Step 2 — Discuss the agent roster
Ask the human:
- "What agents do you use? Just Claude Code locally, or also remote agents?"
- "Are there any tasks the agent should NEVER do without human approval?"
- "Are there recurring triggers you want the agent to handle automatically?"
  (e.g. "when I say 'deploy', follow the deployment playbook")

#### Step 3 — Configure startup behavior
The standard startup behavior for Team Lead:
1. Read CLAUDE.md for project context
2. Read docs/WORKFLOW.md for process
3. Check for module updates: `fd .launchpad --max-depth 2` (or `find . -name ".launchpad" -maxdepth 2`)
4. Check current sprint health (open milestone with 0 open issues → suggest sprint planning)
5. List assigned issues → self-assign if empty

Ask: "Is there anything you want added or changed in the startup sequence?"

#### Step 4 — Project-specific rules and triggers
Ask:
- "Are there modules or parts of the codebase where you want extra caution?"
  (e.g. "don't touch billing without human approval")
- "What commands should the agent never run? What always needs confirmation?"

Use the template at `skills/agents/template.md` as structure.
Show the result to the human for approval.

### If AGENTS.md already exists — Update

1. Find the file: `fd AGENTS.md --max-depth 2 --exclude .git` (or `find . -name "AGENTS.md" -not -path "*/.git/*" -maxdepth 2`)
2. Read the current content
3. Read the template at `skills/agents/template.md` for improvements
4. Common improvements: startup behavior referencing old file paths, missing triggers
5. Update with approved changes, preserving project-specific rules

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Claude reads CLAUDE.md, that's enough" | CLAUDE.md is WHAT this project is. AGENTS.md is HOW the agent operates. Mixing them means either file becomes a dumping ground. |
| "We don't need 'never touch X' rules — I'll just review PRs" | Review at the PR level is too late for destructive actions (force pushes, dropped migrations, deleted production config). Rules are prevention, not review. |
| "Startup behavior is obvious" | It isn't. Without a written sequence, the agent picks a different first action every session — and sometimes skips reading context entirely. |
| "Triggers are just slang, not real automation" | Written triggers turn slang into contract. "Deploy" goes from ambiguous phrase to specific playbook invocation. |
| "AGENTS.md is for humans, let's put it in docs" | AGENTS.md is read by agents at startup. It lives at the repo root next to CLAUDE.md for a reason. |

## Red Flags

- Startup behavior references files that do not exist (e.g. reads `docs/PROCESS.md` when the file is `docs/WORKFLOW.md`)
- "Never do without approval" list is empty despite the project having production or sensitive modules
- Triggers are defined but never reference the corresponding playbook or command
- Agent roster section says "Claude Code" with no role definition — just a name
- AGENTS.md is in `docs/` instead of the repo root (agents look for it at the root)
- Rules contradict CLAUDE.md ("use conventional commits" here, "no commit convention" there)
- File is a copy of the template with no project-specific content

## Verification

- [ ] `AGENTS.md` exists at the repo root (NOT in `docs/`)
- [ ] Agent roster section names each agent in use with a one-line role
- [ ] Startup behavior is a numbered sequence referencing files that actually exist
- [ ] At least one "never do without approval" rule OR an explicit "no such rule needed" note
- [ ] Any trigger listed maps to a concrete playbook or command (no "when I say X, do the thing")
- [ ] Rules do not contradict CLAUDE.md — commit/branch/PR conventions match
- [ ] Project-specific sensitive paths (billing, auth, prod configs) explicitly listed if they exist
- [ ] `.launchpad/manifest.yml` updated with `agents: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `agents: "1.1"` under `modules:`.

Next likely skills:
- `workflow` — if triggers reference playbooks that don't exist yet, add them to WORKFLOW.md
- `identity` — refine Build Identity if agent startup behavior conflicts with declared style
