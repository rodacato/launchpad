# Workflow — Project Customizations

> Base process is in `.launchpad/WORKFLOW.md` (managed by template sync).
> This file contains project-specific customizations that override or extend the base.
> Read the base first, then this file.

---

## Documentation Map

<!-- Update locations and add/remove rows based on which docs this project uses. -->

| Document | Location | Purpose | When to read |
|----------|----------|---------|-------------|
| **CLAUDE.md** | `/CLAUDE.md` | Agent instructions, conventions | Auto-loaded every session |
| **AGENTS.md** | `/AGENTS.md` | Project-specific agent overrides | Session start |
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

## Definition of Done

An issue is done when:

- [ ] Code works end-to-end
- [ ] Tests pass <!-- customize: pnpm test, npm test, bundle exec rspec, etc. -->
- [ ] No type errors <!-- customize: pnpm typecheck, mypy, etc. — delete if not applicable -->
- [ ] Lint passes <!-- customize: pnpm lint, rubocop, etc. -->
- [ ] PR is open with `closes #N` in the body
- [ ] No TODO comments left in changed files
- [ ] Docs updated if behavior changed (see Documentation Sync Rules in base workflow)
- [ ] Human has reviewed and approved
- [ ] PR is merged to `main`

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
# e.g. pnpm test, npm test, bundle exec rspec

# E2E tests
# e.g. pnpm test:e2e, npx playwright test

# Type checking
# e.g. pnpm typecheck, mypy, sorbet

# Lint
# e.g. pnpm lint, rubocop, ruff
```

---

## Project-Specific Playbooks

<!-- Add playbooks specific to this project here.
     Base playbooks (sprint planning, release, spec, ADR) are in .launchpad/WORKFLOW.md -->
