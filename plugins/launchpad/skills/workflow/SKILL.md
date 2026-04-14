---
name: workflow
description: Create or update docs/WORKFLOW.md — the complete team workflow covering build cycle (Issue → Branch → PR → Merge), sprint model, test strategy, playbooks, and definition of done. Use when the team has no written process for how work flows. Use when PRs keep getting merged without tests or reviews. Use when recurring operations (deploys, migrations) are tribal knowledge. Use when the definition of done is "when the author says so".
metadata:
  version: "1.1"
---

# Workflow

## Overview

Create or update `docs/WORKFLOW.md` — the written contract for how work moves from idea to merged code. Build cycle, sprint model, agent workflow, automations, playbooks, test strategy, and definition of done live here. Without this, every developer (and every agent) invents their own process, and "done" means whatever is convenient.

## When to Use

- New project with a vision, roadmap, and architecture but no written process
- PRs are being merged without tests, without linked issues, or without review
- Recurring operations (deploys, migrations, dep bumps) exist only as tribal knowledge
- The team disagrees on what "done" means per task
- The project uses Claude Code or other agents and they lack startup context
- WORKFLOW.md exists but is generic boilerplate — no project-specific playbooks or test commands

**When NOT to use:**
- Solo throwaway prototype with no intent to maintain
- Pre-architecture — the test strategy depends on knowing the layers to test
- As a substitute for the actual issue tracker or CI config

## Before you start

No hard prerequisites, but these improve the output:
- `ARCHITECTURE.md` — informs test strategy (layers, what to mock, commands)
- `CLAUDE.md` — project stack and conventions

Search: `fd ARCHITECTURE.md --exclude .git` (or `find . -name "ARCHITECTURE.md" -not -path "*/.git/*"`)

## Process

### If WORKFLOW.md does NOT exist — Create

#### Step 1 — Review base process
Explain to the human the base workflow:
- Issue → [Spec] → Branch → Implement → Test → PR → Review → Merge
- GitHub Issues are the single source of truth
- Sprints are GitHub Milestones
- Labels: feature, bug, research, chore, blocked, agent:active, agent:review

Ask: "Does this base process work for your project, or are there things to change?"

#### Step 2 — Test strategy
Ask:
- "What testing layers does this project need? (unit, integration, e2e, visual)"
- "What's the test command? What lint/type-check commands exist?"
- "What should be mocked? What should hit real services?"

#### Step 3 — Definition of done
Customize based on the project's stack:
- Tests pass (what command?)
- No type errors (if applicable)
- Lint passes (what tool?)
- PR has `closes #N`
- Docs updated if behavior changed
- Human reviewed and approved
- PR merged to main

#### Step 4 — Project-specific playbooks
Ask: "Are there recurring operations specific to this project that need a playbook?
(e.g. deploying, running migrations, seeding data, updating dependencies)"

Use the template at `skills/workflow/template.md` as structure.
Show the customized workflow to the human for approval.

### If WORKFLOW.md already exists — Update

1. Find the file: `fd WORKFLOW.md --exclude .git --exclude .launchpad` (or `find . -name "WORKFLOW.md" -not -path "*/.git/*" -not -path "*/.launchpad/*"`)
2. Read the current content
3. Read the template at `skills/workflow/template.md` for new sections or playbooks
4. Common improvements: missing playbooks, outdated test commands, new automations
5. Update with approved changes, preserving project-specific customizations

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Everyone on the team already knows the process" | Until someone new joins, or an agent runs cold. "Everyone knows" is a scaling ceiling. |
| "We don't need playbooks, we have a runbook" | A runbook is for incidents. A playbook is for Tuesday. Without playbooks, every deploy is invented fresh. |
| "Definition of done is obvious — tests pass" | Tests passing is necessary, not sufficient. Without a written DoD, 'done' means 'I'm tired of this'. |
| "We don't do sprints" | Fine — but then define how work is scoped and closed. Without a rhythm, work drifts. |
| "Test strategy is the same everywhere" | It isn't. What you mock, what you test at the unit level, and where e2e bites varies by stack and domain. Write yours down. |
| "The agent will figure out the workflow from the code" | The agent will invent a workflow from the code. That's not the same as following yours. |

## Red Flags

- No explicit test command — DoD says "tests pass" without specifying how to run them
- Playbooks section is empty or missing despite the project having recurring ops (deploy, migrate)
- Definition of done has fewer than 4 checks, or checks are vague ("code looks good")
- No `closes #N` convention documented — issues are closed by hand
- Labels listed without definitions — "feature" and "chore" used interchangeably
- Test strategy doesn't mention what to mock vs hit for real — leads to flaky or trivial tests
- No mention of agents despite the project using Claude Code or similar

## Verification

- [ ] `docs/WORKFLOW.md` exists at the project root
- [ ] Build cycle documented: Issue → Branch → PR → Merge with concrete steps
- [ ] Test strategy names every layer used (unit / integration / e2e / visual) with commands
- [ ] Definition of done has at least 5 concrete checks, each runnable or observable
- [ ] At least one project-specific playbook exists (deploy, migration, seed, dep bump, etc.)
- [ ] Branch naming and commit convention documented (e.g. `issue-N-slug`, `type(scope): msg`)
- [ ] PR body convention includes `closes #N` rule
- [ ] Label set defined with one-line meanings
- [ ] `.launchpad/manifest.yml` updated with `workflow: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `workflow: "1.1"` under `modules:`.

Next likely skills:
- `agents` — AGENTS.md startup behavior should read WORKFLOW.md for process
- `architecture` — if test strategy reveals missing architectural boundaries, refine ARCHITECTURE.md
