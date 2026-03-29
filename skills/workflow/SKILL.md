---
name: workflow
description: Create or update WORKFLOW.md — build cycle, sprint model, test strategy, playbooks
metadata:
  version: "1.0"
  author: rodacato
  triggers:
    - workflow
    - "WORKFLOW.md"
    - "build cycle"
    - "test strategy"
    - "definition of done"
---

# Workflow

Create or update `docs/WORKFLOW.md` — the complete team workflow. Covers the build cycle
(Issue → Branch → PR → Merge), sprint model, agent workflow, automations, playbooks,
test strategy, and definition of done.

## Before you start

No hard prerequisites, but these improve the output:
- `ARCHITECTURE.md` — informs test strategy (layers, what to mock, commands)
- `CLAUDE.md` — project stack and conventions

Search: `find . -name "ARCHITECTURE.md" -not -path "*/.git/*"`

---

## If WORKFLOW.md does NOT exist — Create

### Step 1 — Review base process
Explain to the human the base workflow:
- Issue → [Spec] → Branch → Implement → Test → PR → Review → Merge
- GitHub Issues are the single source of truth
- Sprints are GitHub Milestones
- Labels: feature, bug, research, chore, blocked, agent:active, agent:review

Ask: "Does this base process work for your project, or are there things to change?"

### Step 2 — Test strategy
Ask:
- "What testing layers does this project need? (unit, integration, e2e, visual)"
- "What's the test command? What lint/type-check commands exist?"
- "What should be mocked? What should hit real services?"

### Step 3 — Definition of done
Customize based on the project's stack:
- Tests pass (what command?)
- No type errors (if applicable)
- Lint passes (what tool?)
- PR has `closes #N`
- Docs updated if behavior changed
- Human reviewed and approved
- PR merged to main

### Step 4 — Project-specific playbooks
Ask: "Are there recurring operations specific to this project that need a playbook?
(e.g. deploying, running migrations, seeding data, updating dependencies)"

Use the template at `skills/workflow/template.md` as structure.
Show the customized workflow to the human for approval.

---

## If WORKFLOW.md already exists — Update

1. Find the file: `find . -name "WORKFLOW.md" -not -path "*/.git/*" -not -path "*/.launchpad/*"`
2. Read the current content
3. Read the template at `skills/workflow/template.md` for new sections or playbooks
4. Common improvements: missing playbooks, outdated test commands, new automations
5. Update with approved changes, preserving project-specific customizations

---

## When done

Update `.launchpad/manifest.yml` — set `workflow: "1.0"` under `modules:`.
