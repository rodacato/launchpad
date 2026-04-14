---
name: contributing
description: Create or update CONTRIBUTING.md — dev setup, branch conventions, PR process, testing expectations. Use when starting a new open-source or internal project. Use when onboarding contributors and they keep asking the same setup questions. Use when CONTRIBUTING.md is missing or stale. Use when PR hygiene is inconsistent across the team.
metadata:
  version: "1.1"
---

# Contributing

## Overview

Create or update `CONTRIBUTING.md` — the contributor's runbook. Dev environment
setup, branch naming, commit conventions, how to open a PR, code style, and
testing expectations. If a new contributor can't clone, set up, run tests, and
open their first PR using only this file, it has failed its job.

## When to Use

- Brand new project where contributors (human or agent) will land and need a path in
- Project has `AGENTS.md` / `WORKFLOW.md` but no external-facing contribution guide
- Contributors keep asking the same setup questions in chat or issues
- PR hygiene is inconsistent — missing `closes #N`, wrong branch names, mixed commit types
- Open sourcing an internal project and you need a public-facing guide

**When NOT to use:**
- One-off scripts, spikes, or personal repos with no external contributors
- Repos where the README already fully covers dev setup AND PR process (duplication is worse than absence)
- Pure vendor / dependency repos that only receive bot PRs

## Before you start

Search for these files — they usually contain most of what the guide needs:

- `AGENTS.md` — workflow conventions, branch naming, commit format
- `WORKFLOW.md` — test commands, definition of done, CI expectations
- Existing `README.md` — may already have setup instructions to cross-reference

```bash
fd AGENTS.md --exclude .git
fd WORKFLOW.md --exclude .git --exclude .launchpad
fd README.md --exclude .git --max-depth 2
```

If none of those exist, you will be sourcing everything from the human in Step 2.

## Process

### If CONTRIBUTING.md does NOT exist — Create

#### Step 1 — Gather project info
From `AGENTS.md` / `WORKFLOW.md` / `README.md`, extract:
- Dev environment setup (devcontainer, docker-compose, local toolchain)
- Branch naming convention (e.g. `issue-{N}-{slug}`)
- Commit type convention (conventional commits? types allowed?)
- Test command(s) — unit, integration, e2e
- Lint / typecheck / format commands
- PR requirements (`closes #N`, required reviewers, CI green)

#### Step 2 — Ask the human the gaps
- "Is this open source or internal? (affects tone and legal section)"
- "Do contributors need to sign a CLA or DCO?"
- "Any non-obvious environment requirements? (specific Node version, API keys for local dev, etc.)"
- "What's the expected PR review SLA?"
- "Is there a code of conduct, or should one be linked?"

#### Step 3 — Create CONTRIBUTING.md
Use this structure (in this order):
1. Prerequisites (tools, accounts, access)
2. Dev environment setup (commands, first-run gotchas)
3. Running tests (all commands + how to run a single test)
4. Branch and commit conventions
5. Opening a PR (template, `closes #N`, review expectations)
6. Code review process (who reviews, what's checked)
7. Reporting issues (issue template, triage labels)
8. Code of conduct / CLA / DCO (if applicable)

Show the draft to the human. Wait for approval before writing the file.

### If CONTRIBUTING.md already exists — Update

1. Locate it: `fd CONTRIBUTING.md --exclude .git`
2. Read the current file end-to-end
3. Check for: outdated commands, missing sections from the structure above,
   divergence from `AGENTS.md` / `WORKFLOW.md`, broken links
4. Propose the diff to the human
5. Update with approved changes — preserve project-specific content (voice,
   custom sections, legal text)

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The README already says how to run tests" | Split concerns: README is for users, CONTRIBUTING.md is for contributors. If both exist, link — don't duplicate the content in both places. |
| "We're a small team, we all know how it works" | The team of tomorrow is larger than the team of today. And future-you is a contributor who forgot the gotchas. |
| "I'll just copy CONTRIBUTING.md from another repo" | A copied guide has the wrong commands, the wrong branch pattern, and stale links. Five minutes of copy-paste creates hours of debugging. |
| "AGENTS.md covers this for the AI, humans can figure it out" | Humans need the `why` behind conventions. AGENTS.md is terse on purpose; CONTRIBUTING.md explains. |
| "We'll document it properly once the project is stable" | "Stable" never arrives. Undocumented projects calcify their tribal knowledge into a wall that keeps contributors out. |

## Red Flags

- File exists but has no test-run command, or the command is wrong / outdated
- Branch naming convention contradicts what `AGENTS.md` specifies
- "Open a PR" section with no template, no `closes #N` guidance, no review expectation
- Setup instructions assume tools already installed without listing versions
- No section on running a single test — forces contributors to read CI logs to learn
- CLA / DCO / code of conduct missing on an open-source project
- Commands reference a build system the repo no longer uses

## Verification

- [ ] `CONTRIBUTING.md` exists at project root (not buried in `docs/`)
- [ ] Prerequisites section lists specific versions for critical tools (Node 20+, Ruby 3.2+, etc.)
- [ ] At least one full test command is present and actually works when pasted into a fresh shell
- [ ] Branch naming convention matches `AGENTS.md` / `WORKFLOW.md` exactly
- [ ] PR section mentions `closes #N` or the project's equivalent issue-linking convention
- [ ] "Reporting issues" section exists with either a template link or explicit triage expectations
- [ ] If open source: CoC, CLA/DCO, and license references are present or explicitly marked N/A
- [ ] `.launchpad/manifest.yml` updated with `contributing: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `contributing: "1.1"` under `modules:`.

Next likely skills:
- `changelog` — once contribution process is clear, define how shipped work is recorded
- `releasing` — pair with CHANGELOG to formalize how versions are cut
- `code-review` (lifecycle) — the other half of the PR process this skill documents
