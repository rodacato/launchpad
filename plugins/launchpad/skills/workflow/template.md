# Workflow

> How work flows through this project. Read this at the start of every session.
> Issues are the single source of truth. Agents work issues. Humans create, prioritize, and review.

```
Idea → Roadmap → Issue → [Spec] → Branch → Implement → Test → PR → Review → Merge
                            ↓
                  ADR (if architectural decision needed)
```

---

## The Build Cycle

### 1. Capture the idea
Small (< 2 hours, well-defined): create a GitHub Issue directly.
Bigger: add to **Backlog** in `docs/ROADMAP.md` first.

### 2. Prioritize
During sprint planning, move items from Backlog to "What's Next", then create Issues
and assign to a Milestone.

### 3. Spec (for non-trivial features)
Before building anything touching multiple layers, write a spec at `docs/specs/<feature>.md`:
- **Scope** — what's in, what's out
- **Technical approach** — how it works
- **File-by-file plan** — specific files to create or modify
- **Verification steps** — how to confirm it works

Not every issue needs a spec. Bug fixes and small features go straight to code.

### 4. Consult the expert panel (when uncertain)
For cross-cutting decisions, consult `docs/EXPERTS.md`:
```
"Panel, evaluate these 3 options for [feature]."
"Security + Architect: review this flow for auth gaps."
```

### 5. Record architectural decisions
Write an ADR at `docs/adr/NNN-short-title.md` when a decision involved tradeoffs:
```markdown
# ADR-NNN: Title
**Status:** accepted | superseded | deprecated
**Date:** YYYY-MM-DD

## Context
## Decision
## Alternatives Considered
## Consequences
```

### 6. Implement
Follow the spec if one exists. Keep changes small, reviewable, reversible.
One feature or fix per PR.

### 7. Test & ship
Run tests, update docs, open PR. See Definition of Done below.

---

## Sprint Model

Sprints are GitHub Milestones with name: `Sprint N — short description`

**Issues vs PRs**: Only issues go on the project board and milestones.
PRs are NOT added to the board — they connect via `closes #N` in the PR body.

```bash
# Create a sprint
gh api repos/{owner}/{repo}/milestones -f title="Sprint 1 — Foundation" -f due_on="YYYY-MM-DDT00:00:00Z"

# Assign an issue
gh issue edit 14 --milestone "Sprint 1 — Foundation"
```

---

## Agent Workflow

```bash
# 1. Check assigned work
gh issue list --assignee @me --state open

# 2. If nothing, show current sprint
gh issue list --milestone "Sprint N" --state open --limit 20

# 3. Pick and self-assign
gh issue edit {N} --add-assignee @me --add-label "agent:active"

# 4. Create branch
git checkout -b issue-{N}-{short-description}

# 5. Work the issue — code, tests, docs

# 6. Commit
git commit -m "feat(scope): what was done — closes #N"

# 7. Open PR
gh pr create --title "feat: description (#N)" --body "closes #{N}" --draft

# 8. Mark ready for review
gh pr ready
```

---

## Labels

| Label | Meaning |
|---|---|
| `feature` | New functionality |
| `bug` | Something broken |
| `research` | Explore before building |
| `chore` | Maintenance, deps, config |
| `blocked` | Waiting on something external |
| `agent:active` | Agent is working this |
| `agent:review` | Agent opened PR, waiting review |

---

## Automations

| Workflow | Trigger | Action |
|----------|---------|--------|
| `enforce-issue-link.yml` | PR opened/edited | Fails if body is missing `closes #N` |
| `pr-labels.yml` | PR opened/ready | Syncs `agent:active` / `agent:review` labels |

GitHub Projects built-in: configure in board UI (Menu → Workflows):
- Auto-add new issues → status "Todo"
- Item closed → status "Done"
- Pull request merged → status "Done"

---

## Commit Convention

```
type(scope): short description

Types: feat | fix | docs | refactor | test | chore | perf | release
Scope: optional — e.g. auth | api | cli | db | ui
```

## Branch Naming

```
issue-{number}-{short-description}
```

---

## Definition of Done

An issue is done when:

- [ ] Code works end-to-end
- [ ] Tests pass <!-- customize: pnpm test, bundle exec rspec, etc. -->
- [ ] No type errors <!-- delete if not applicable -->
- [ ] Lint passes <!-- customize: pnpm lint, rubocop, etc. -->
- [ ] PR is open with `closes #N` in the body
- [ ] No TODO comments left in changed files
- [ ] Docs updated if behavior changed
- [ ] Human has reviewed and approved
- [ ] PR is merged to `main`

---

## Test Strategy

| Layer | Test type | What to test | External deps |
|---|---|---|---|
| Domain | Unit | Aggregate invariants, pure logic | None |
| Application | Unit | Use case orchestration | Mock all ports |
| Infrastructure | Integration | Repos, routes, external clients | Real DB (test container) |
| Full system | E2E | Critical user flows | Mock external services |

```bash
# Unit + integration tests
# e.g. pnpm test, npm test, bundle exec rspec

# E2E tests
# e.g. pnpm test:e2e, npx playwright test

# Type checking
# e.g. pnpm typecheck, mypy

# Lint
# e.g. pnpm lint, rubocop, ruff
```

---

## Documentation Map

| Document | Location | When to read |
|----------|----------|-------------|
| **CLAUDE.md** | `/CLAUDE.md` | Auto-loaded every session |
| **AGENTS.md** | `/AGENTS.md` | Session start |
| **VISION.md** | `docs/VISION.md` | Scope or direction decisions |
| **IDENTITY.md** | `docs/IDENTITY.md` | Calibrating approach |
| **EXPERTS.md** | `docs/EXPERTS.md` | Tradeoffs, cross-cutting decisions |
| **ARCHITECTURE.md** | `docs/ARCHITECTURE.md` | Before writing code |
| **ROADMAP.md** | `docs/ROADMAP.md` | Before starting any feature |
| **BRANDING.md** | `docs/BRANDING.md` | Building or modifying UI |
| **ADRs** | `docs/adr/` | Past decisions, new architectural choices |
| **Specs** | `docs/specs/` | Before building a roadmap feature |

---

## Playbooks

### Sprint Planning
1. Review `docs/ROADMAP.md` — "What's Next" and Backlog
2. Ask human which items to include
3. Define sprint goal (one sentence)
4. Create milestone: `gh api repos/{owner}/{repo}/milestones -f title="Sprint N — Name" -f due_on="YYYY-MM-DDT00:00:00Z"`
5. Create issues, assign to milestone
6. Update ROADMAP.md

### Close a Sprint
1. List all issues: `gh issue list --milestone "Sprint N" --state all`
2. Verify all committed issues are closed
3. Close milestone: `gh api repos/{owner}/{repo}/milestones/{id} -X PATCH -f state="closed"`
4. Update ROADMAP.md (sprint history, What's Been Built)
5. Quick retro with the human

### Prepare a Release
1. Read ROADMAP.md — identify everything shipped since last release
2. Update CHANGELOG.md
3. Bump version in relevant files
4. `git commit -m "release: vX.Y.Z"` + `git tag vX.Y.Z` + `git push && git push --tags`
5. `gh release create vX.Y.Z --notes-from-tag`

### Write a Spec
1. Read the related issue or Roadmap entry
2. Consult relevant experts
3. Create `docs/specs/<feature-name>.md`: scope, approach, file plan, verification
4. Link spec in the GitHub Issue
5. Update ROADMAP.md spec history

### Record an ADR
1. Identify the decision and alternatives
2. Create `docs/adr/NNN-short-title.md`
3. Update ROADMAP.md ADR history
4. Update ARCHITECTURE.md if the decision changes system design

---

## Project-Specific Playbooks

<!-- Add playbooks specific to this project here. -->
