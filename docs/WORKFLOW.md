# Workflow

> How work is organized in this project. Both humans and agents follow this document.
> Documentation is the foundation, not an afterthought. Before writing code,
> the intention lives in a document. Before merging, the docs reflect the reality.

---

<!-- AGENT INSTRUCTIONS — How to customize this document

This is the one doc that should be MOSTLY consistent across projects.
The core process (GitHub Issues, Milestones, build cycle) stays the same.
What changes per project:

  - Definition of done (adapt to the stack — testing commands, type checking, etc.)
  - Test strategy (adapt to the architecture — what layers, what mocks)
  - Documentation sync rules (adapt to which docs this project has)
  - Playbooks (add project-specific recurring operations)

DURING PROJECT SETUP (START_HERE.md Phase 2):
  After Architecture is defined, revisit this file and:
  1. Fill in the test strategy based on the chosen architecture
  2. Fill in the test/lint/typecheck commands
  3. Customize the definition of done
  4. Add any project-specific playbooks
  5. Update the documentation map with actual file locations

-->

## Mental Model

Work flows through GitHub Issues. Issues are the single source of truth.
Agents work issues. Humans create, prioritize, and review.

```
Idea → Roadmap → Issue → [Spec] → Branch → Implement → Test → PR → Review → Merge
                            ↓
                  ADR (if architectural decision needed)
```

---

## Documentation Map

<!-- Update locations and add/remove rows based on which docs this project uses. -->

| Document | Location | Purpose | When to read |
|----------|----------|---------|-------------|
| **CLAUDE.md** | `/CLAUDE.md` | Agent instructions, conventions | Auto-loaded every session |
| **AGENTS.md** | `/AGENTS.md` | Agent roles and startup behavior | Session start |
| **VISION.md** | `docs/VISION.md` | Project compass — philosophy, litmus test | Scope or direction decisions |
| **IDENTITY.md** | `docs/IDENTITY.md` | Build persona — decision style, quality bar | Calibrating approach |
| **EXPERTS.md** | `docs/EXPERTS.md` | Expert advisory panel | Tradeoffs, cross-cutting decisions |
| **ARCHITECTURE.md** | `docs/ARCHITECTURE.md` | System design, domain model, tech decisions | Before writing code |
| **ROADMAP.md** | `docs/ROADMAP.md` | What's built, what's next, backlog, decision log | Before starting any feature |
| **BRANDING.md** | `docs/BRANDING.md` | Colors, typography, voice, UI patterns | Building or modifying UI |
| **CHANGELOG.md** | `/CHANGELOG.md` | Version history | Releases, checking what shipped |
| **ADRs** | `docs/adr/` | Architecture Decision Records | Past decisions, new architectural choices |
| **Specs** | `docs/specs/` | Feature implementation blueprints | Before building a roadmap feature |

---

## The Build Cycle

### 1. Capture the idea

If it's small (< 2 hours, well-defined): create a GitHub Issue directly.
If it's bigger: add to the **Backlog** in `docs/ROADMAP.md` first.

### 2. Prioritize

During sprint planning, move items from Backlog to "What's Next" in the Roadmap,
then create GitHub Issues and assign them to a Milestone.

### 3. Spec (for non-trivial features)

Before building anything that touches multiple layers or involves tradeoffs,
write a spec at `docs/specs/<feature-name>.md`:

- **Scope** — what's in, what's out
- **Technical approach** — how it works, which layers it touches
- **File-by-file plan** — specific files to create or modify
- **Verification steps** — concrete steps to confirm it works

Not every issue needs a spec. Bug fixes, chores, and small features go straight to code.

### 4. Consult the expert panel (when uncertain)

For cross-cutting decisions, consult `docs/EXPERTS.md`:

```
"Panel, evaluate these 3 options for [feature]."
"Security + Architect: review this flow for auth gaps."
```

### 5. Record architectural decisions

If a decision involved tradeoffs or debate, write an ADR at `docs/adr/NNN-short-title.md`:

```markdown
# ADR-NNN: Title
**Status:** accepted | superseded | deprecated
**Date:** YYYY-MM-DD

## Context
What situation forced this decision?

## Decision
What was decided and why?

## Alternatives Considered
What else was evaluated and why it was not chosen?

## Consequences
What does this make easier? Harder? What's the rollback plan?
```

ADRs are never deleted. Superseded ones are marked as such.
The Decision Log in `docs/ROADMAP.md` is the summary; ADRs hold the full reasoning.

### 6. Implement

Follow the spec if one exists. Reference `CLAUDE.md` for conventions.
Keep changes small, reviewable, and reversible. One feature or fix per PR.

### 7. Test & ship

Run the project's test suite, update docs, open PR. See Definition of Done below.

---

## Issue Types and Labels

| Label | Meaning | Who creates |
|---|---|---|
| `feature` | New functionality | Human |
| `bug` | Something broken | Human or agent |
| `research` | Explore before building | Human |
| `chore` | Maintenance, deps, config | Human |
| `blocked` | Waiting on something external | Anyone |
| `agent:active` | An agent is currently working this | Agent (self-assigned) |
| `agent:review` | Agent opened PR, waiting human review | Auto via PR |

---

## Sprint Model

Sprints are GitHub Milestones. Each milestone has:
- A name: `Sprint N — short description`
- A due date (optional but recommended)
- A set of issues

```bash
# Create a sprint
gh api repos/{owner}/{repo}/milestones -f title="Sprint 1 — Foundation" -f due_on="2026-04-15T00:00:00Z"

# Assign an issue to a sprint
gh issue edit 14 --milestone "Sprint 1 — Foundation"

# View the current sprint
gh issue list --milestone "Sprint 1 — Foundation" --state open
```

---

## Agent Workflow

When an agent starts a session:

```bash
# 1. Check for assigned work
gh issue list --assignee @me --state open

# 2. If nothing assigned, show current sprint
gh issue list --milestone "Sprint N" --state open --limit 20

# 3. Pick an issue and self-assign
gh issue edit {N} --add-assignee @me --add-label "agent:active"

# 3b. Move issue to "In Progress" on the project board
#     Get the project number from CLAUDE.md → GitHub Project Number
gh project item-add {PROJECT_NUMBER} --owner {org} --url https://github.com/{owner}/{repo}/issues/{N}
gh project item-edit --project-id {PROJECT_NUMBER} --id {ITEM_ID} --field-id {STATUS_FIELD_ID} --single-select-option-id {IN_PROGRESS_ID}
# Tip: use `gh project field-list {PROJECT_NUMBER} --owner {org}` to find field/option IDs

# 4. Create a branch
git checkout -b issue-{N}-{short-description}

# 5. If the issue has a spec, read it first
# Check docs/specs/ for a matching spec

# 6. Work the issue — code, tests, docs

# 7. Commit following convention
git commit -m "feat(scope): what was done — closes #N"

# 8. Push and open PR
gh pr create --title "feat: description (#N)" --body "closes #{N}" --draft

# 9. When ready for review
gh pr ready
gh issue edit {N} --remove-label "agent:active" --add-label "agent:review"
# Move to "Done" on the project board
gh project item-edit --project-id {PROJECT_NUMBER} --id {ITEM_ID} --field-id {STATUS_FIELD_ID} --single-select-option-id {DONE_ID}

# 10. Address PR review feedback (triggered by human)
#     Read all review comments and threads on the PR
gh api repos/{owner}/{repo}/pulls/{PR_NUMBER}/comments
gh pr view {PR_NUMBER} --json reviews,comments

#     For each comment:
#       - If actionable: fix the code, commit, push
#       - If you disagree: reply with technical reasoning, do NOT resolve
#       - If it's a question: answer in the thread
#     After pushing fixes, resolve addressed threads:
gh api graphql -f query='
  mutation($threadId:ID!) {
    resolveReviewThread(input:{threadId:$threadId}) {
      thread { isResolved }
    }
  }' -f threadId="{THREAD_NODE_ID}"
#     Get thread IDs from: gh api repos/{owner}/{repo}/pulls/{PR_NUMBER}/reviews
```

---

## Human Workflow

### Sprint planning

```bash
# See all open issues
gh issue list --state open

# Create issues (use templates)
gh issue create --template feature.md

# Assign to sprint
gh issue edit {N} --milestone "Sprint N"
```

### Reviewing a PR

1. Open the PR link from `gh pr list`
2. Review the diff
3. Comment, request changes, or approve
4. Merge with "Squash and merge" — this closes the linked issue automatically

---

## Commit Convention

```
type(scope): short description

Types: feat | fix | docs | refactor | test | chore | perf | release
Scope: optional — e.g. auth | api | cli | db | ui

Examples:
  feat(api): add search endpoint with pgvector
  fix(cli): handle empty results gracefully
  docs(readme): update installation steps
  chore(deps): bump ruby to 3.3.1
  release: v0.2.0
```

---

## Branch Naming

```
issue-{number}-{short-description}

Examples:
  issue-14-search-endpoint
  issue-22-fix-auth-timeout
  issue-31-update-readme
```

Branches from `main`. Nothing goes to `main` without a PR.

---

## Definition of Done

An issue is done when:

- [ ] Code works end-to-end
- [ ] Tests pass <!-- customize: pnpm test, npm test, bundle exec rspec, etc. -->
- [ ] No type errors <!-- customize: pnpm typecheck, mypy, etc. — delete if not applicable -->
- [ ] Lint passes <!-- customize: pnpm lint, rubocop, etc. -->
- [ ] PR is open with `closes #N` in the body
- [ ] No TODO comments left in changed files
- [ ] Docs updated if behavior changed (see Documentation Sync Rules)
- [ ] Human has reviewed and approved
- [ ] PR is merged to `main`

---

## Documentation Sync Rules

When making changes, update the corresponding docs **in the same commit or PR**:

| If you change... | Update... |
|---|---|
| New/changed API endpoint | `README.md` |
| New/changed env var | `README.md` + `.env.example` |
| New feature shipped | `CHANGELOG.md` + mark done in `docs/ROADMAP.md` |
| Architectural decision | `docs/adr/` + Decision Log in `docs/ROADMAP.md` |
| New port, adapter, or layer | `docs/ARCHITECTURE.md` |
| Auth or security change | `README.md` security section |
| Completed roadmap item | `docs/ROADMAP.md` — move to "What's Been Built" |
| Sprint closed | `docs/ROADMAP.md` — sprint history table |

---

## Test Strategy

<!-- CUSTOMIZE per project based on the architecture.
     Delete the sections that don't apply. -->

### By layer

| Layer | Test type | What to test | External deps |
|---|---|---|---|
| Domain | Unit | Aggregate invariants, value objects, pure logic | None |
| Application | Unit | Use case orchestration, event publishing | Mock all ports |
| Infrastructure | Integration | Repos, routes, external clients | Real DB (test container), mock external APIs |
| Full system | E2E | Critical user flows end-to-end | Mock external services |

### Commands

```bash
# Unit + integration tests
<!-- e.g. pnpm test, npm test, bundle exec rspec -->

# E2E tests
<!-- e.g. pnpm test:e2e, npx playwright test -->

# Type checking
<!-- e.g. pnpm typecheck, mypy, sorbet -->

# Lint
<!-- e.g. pnpm lint, rubocop, ruff -->
```

---

## Playbooks

Step-by-step checklists for recurring operations. Follow exactly to keep all documents consistent.

---

### Playbook: Sprint Planning

Triggered by: "planifiquemos el sprint" / "let's plan the sprint"

1. Review `docs/ROADMAP.md` — "What's Next" and Backlog sections
2. Ask the human which items to include in the next sprint
3. Define the sprint goal (one sentence)
4. Create the milestone: `gh api repos/{owner}/{repo}/milestones -f title="Sprint N — Name" -f due_on="YYYY-MM-DDT00:00:00Z"`
5. Create issues for each committed item (use templates from `.github/ISSUE_TEMPLATE/`)
6. Assign all issues to the milestone
7. Update `docs/ROADMAP.md` — move items to "What's Next" with status `backlog`
8. Confirm — show the sprint to the human

---

### Playbook: Close a Sprint

Triggered by: "cerremos el sprint" / "close the sprint"

1. List all issues in the milestone: `gh issue list --milestone "Sprint N" --state all`
2. Verify: are all committed issues closed? If not, discuss with human.
3. Move incomplete issues to the next sprint or back to backlog
4. Close the milestone: `gh api repos/{owner}/{repo}/milestones/{id} -X PATCH -f state="closed"`
5. Update `docs/ROADMAP.md`:
   - Sprint history: add a row with outcome and ✅ Closed
   - "What's Been Built": move completed features
   - "What's Next": update statuses
6. Quick retro — ask the human: "What went well? What slowed us down? What changes for next time?"
7. Save retro notes as a comment on the closed milestone or in the sprint history

---

### Playbook: Prepare a Release

Triggered by: "preparemos un release" / "let's cut a release"

1. Read `docs/ROADMAP.md` — identify everything shipped since last release
2. Update `CHANGELOG.md` — group changes under `feat` / `fix` / `chore` / `docs`
3. Bump version in relevant files (package.json, gemspec, pyproject.toml, etc.)
4. Commit: `git commit -m "release: vX.Y.Z"`
5. Tag: `git tag vX.Y.Z`
6. Push: `git push && git push --tags`
7. Create GitHub release: `gh release create vX.Y.Z --notes-from-tag`
8. Update `docs/ROADMAP.md` — mark the milestone as shipped
9. Confirm — show the release URL to the human

---

### Playbook: Write a Spec

Triggered by: "escribí una spec para X" / "write a spec for X"

1. Read the related issue or Roadmap entry
2. Consult the relevant experts if the feature involves tradeoffs
3. Create `docs/specs/<feature-name>.md` with: scope, technical approach, file-by-file plan, verification steps
4. Link the spec in the GitHub Issue
5. Update `docs/ROADMAP.md` spec history — add a row
6. Confirm — show the spec to the human for review

---

### Playbook: Record an ADR

Triggered by: "documentemos esta decisión" / "let's write an ADR"

1. Identify the decision and alternatives considered
2. Consult the relevant experts for their perspectives
3. Create `docs/adr/NNN-short-title.md` using the ADR format
4. Update `docs/ROADMAP.md` — add to ADR history table and Decision Log
5. Update `docs/ARCHITECTURE.md` if the decision changes the system design
6. Confirm — show the ADR to the human

---

## Blocked Work

If work is blocked, label it and explain why:

```bash
gh issue comment {N} --body "Blocked: waiting on X to resolve Y"
gh issue edit {N} --add-label "blocked"
```

When unblocked:

```bash
gh issue edit {N} --remove-label "blocked"
gh issue comment {N} --body "Unblocked: X resolved"
```
