---
name: sdd-plan
description: SDD-lite step 2 — writes docs/sdd/<change-name>/plan.md with the chosen design, alternatives considered, and the rationale that picked between them. Reads spec.md first; refuses to plan against a draft or contradictory spec. Use after sdd-spec is accepted and you need to commit to an approach. Use when a change has multiple plausible designs and the team needs to pick one. NOT for picking between trivial implementation styles — those belong inline in the code review.
metadata:
  version: "0.1"
---

# SDD Plan

## Overview

Step 2 of SDD-lite. Writes `docs/sdd/<change-name>/plan.md` — the chosen
design that satisfies the accepted spec. Always documents at least 2
alternatives considered and the explicit reason for picking one. A plan
without rejected alternatives is a recommendation no one stress-tested.

## When to Use

- `sdd-spec` produced an accepted spec and the next step is committing to a design
- Multiple plausible designs exist and the team needs to lock one before implementation starts
- The chosen approach has non-obvious tradeoffs that future readers (or future-you) will want to understand
- The change crosses module boundaries and someone needs to see the system view before any code lands

**When NOT to use:**
- Spec is still `draft` or has unresolved open questions — fix those first
- The implementation is mechanically obvious (CRUD on a known table, rename across files) — skip planning, go to tasks
- You're already mid-implementation and trying to retrofit a plan — commit message + ADR is the right artifact instead

## Before you start

Required: `docs/sdd/<change-name>/spec.md` with status `accepted`. If the
spec isn't accepted, STOP — go back to the human and resolve the spec
first. A plan against a moving spec is wasted work.

```bash
cat docs/sdd/<change-name>/spec.md  # confirm status: accepted
fd ARCHITECTURE.md docs --exclude .git
fd IDENTITY.md docs --exclude .git  # tiebreakers live here
```

ARCHITECTURE.md tells you the existing patterns the design must respect or
deliberately deviate from. IDENTITY.md tells you the project's tiebreaker
hierarchy (simplicity vs. performance vs. DX) — that's how you defend the
chosen alternative.

## Process

### Step 1 — Re-read the spec end-to-end

Do not start designing until the spec is in your head. Pay specific
attention to:
- Constraints — these often eliminate options before you consider them
- Out-of-scope — the design must not require those items to function
- Success criteria — every design choice must serve at least one criterion

If you find yourself wanting a constraint relaxed or an out-of-scope item
included: STOP. That's a spec amendment, not a plan choice. Take it back
to the human.

### Step 2 — Generate alternatives

Before designing the chosen approach, list at LEAST two alternatives.
Format:

```
ALTERNATIVE A: <one-line name>
- Sketch: <how it works in 2-3 bullets>
- Pros: ...
- Cons: ...
- Rejected because: <which constraint or tiebreaker fails>

ALTERNATIVE B: ...
```

If you can only think of one alternative, you haven't thought hard enough.
Possible second alternatives to push for:
- Do nothing (or do less) — what breaks?
- Use the boring established pattern — why isn't that good enough?
- Buy / borrow / reuse — is there an existing thing that solves this?

### Step 3 — Design the chosen approach

Now design the one you'll recommend. Cover:

- **Architecture / data flow**: a diagram (ASCII or sketch) showing the
  pieces and how data moves between them
- **Module / file changes**: which files are touched, which are new,
  which are deleted
- **Key decisions with rationale**: each non-obvious choice gets a
  one-paragraph WHY
- **Risks**: what could go wrong; how you'd mitigate
- **Rollback**: how to undo this change if it ships and breaks something

### Step 4 — Draft the plan file

Create `docs/sdd/<change-name>/plan.md` with the structure below.

```markdown
# Plan — <change-name>

> Step 2 of SDD-lite. Status: draft | accepted | shipped
> Spec: [spec.md](./spec.md) (status: accepted)

## Summary

One paragraph. The chosen approach in plain language.

## Alternatives considered

### Alternative A — <name> (CHOSEN)

- Sketch: ...
- Pros: ...
- Cons: ...
- Why we chose it: <which spec criteria + which IDENTITY tiebreaker>

### Alternative B — <name> (rejected)

- Sketch: ...
- Pros: ...
- Cons: ...
- Why we rejected it: <specific constraint or tiebreaker that fails>

### Alternative C — <name> (rejected)

(same shape)

## Architecture

ASCII diagram or prose showing the pieces and the flow.

## Module / file changes

- new: `path/to/file`
- modified: `path/to/file` (what changes)
- deleted: `path/to/file` (why)

## Key decisions

Each non-obvious choice — short title + one paragraph WHY.

## Risks and mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| ... | ... | ... | ... |

## Rollback plan

Concrete steps to undo the change if it ships and breaks something. If
"redeploy previous version" is enough, say so explicitly. If it needs
data migration / cleanup, write the steps.

## Open questions

Things that still need answers before sdd-tasks. Same shape as the spec's
table.

## References

- Spec: ./spec.md
- Issue: #<N>
- Related ADRs / docs: ...
```

### Step 5 — Show the draft + iterate

Share with the human. Iterate. The most common rework: alternatives that
weren't seriously considered ("Alternative B is obviously worse") need to
be replaced with options the human would actually choose between.

Lock status to `accepted` only with explicit human approval.

### Step 6 — Write the file

Create `docs/sdd/<change-name>/plan.md`. Commit:
`docs(sdd): add plan for <change-name>`.

### Step 7 — Hand off

```
Plan written: docs/sdd/<change-name>/plan.md (status: accepted)
Open questions: <count>
Next step: /lifecycle:sdd-tasks <change-name>  (after open questions resolve)
```

Do NOT auto-run sdd-tasks. The human drives the transition.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll skip alternatives — the chosen one is obvious" | If it's obvious, naming the rejected ones costs nothing and pre-empts "did you consider X?" mid-implementation. If it ISN'T obvious (it usually isn't), alternatives are the whole value of the plan. |
| "Rollback plan can wait until something breaks" | The cheapest moment to write the rollback is when you remember the design. The most expensive moment is at 2am when prod is down. Write it now. |
| "Risks section is just speculation, skip it" | Risks you didn't write down are risks you didn't think about. The exercise of listing them surfaces hidden assumptions; you don't have to be exhaustive — just honest. |
| "I'll inline rationale in code comments instead of a plan section" | Code comments rot; design docs persist. The WHY of the architecture deserves a stable home that survives refactors. |
| "The plan duplicates the spec — I'll merge them" | Spec = problem. Plan = solution. Merging hides which choices are non-negotiable (spec) vs. which are this team's pick this week (plan). The next person needs to know the difference. |
| "I'll plan and tasks in one step" | Plan asks 'what's the right approach?'. Tasks asks 'in what order do I touch which file?'. Mixing them produces a tasks list that is also a half-baked plan, satisfying neither audience. |

## Red Flags

- Only one "alternative" listed (and it's the chosen one) — alternatives section is theater
- Rejected alternatives are obvious strawmen no team would seriously consider
- "Why we chose it" doesn't reference any spec criterion or IDENTITY tiebreaker — choice is unjustified
- Architecture diagram missing for a multi-module change
- "Risks" section is empty or contains only generic risks ("might be slow")
- Rollback plan is missing or says "we'll figure it out"
- Plan contradicts the spec (relaxes a constraint, includes an out-of-scope item) without flagging it as a spec amendment
- Status is `accepted` while open questions remain
- The plan changes the spec's success criteria without going back to amend the spec

## Verification

- [ ] `docs/sdd/<change-name>/plan.md` exists
- [ ] Spec is `accepted` (verified by re-reading the spec status field)
- [ ] At least 2 alternatives listed beyond the chosen one
- [ ] Each alternative has Sketch / Pros / Cons / Rejected-because
- [ ] "Why we chose it" cites a specific spec criterion AND a specific IDENTITY tiebreaker
- [ ] Architecture diagram (ASCII or prose) present for any multi-module change
- [ ] Risks table has at least 2 rows with Likelihood / Impact / Mitigation
- [ ] Rollback plan present and concrete (not "we'll figure it out")
- [ ] Status reflects reality (`accepted` only after human approval)
- [ ] Plan does NOT silently change the spec — any change is a spec amendment first
- [ ] Commit landed with `docs(sdd): add plan for <change-name>`

## When done

Nothing to update in `.launchpad/manifest.yml` — sdd-plan is a lifecycle
skill and produces a workflow artifact (plan.md), not a project artifact.

Next likely skills:
- `lifecycle:sdd-tasks` — break this plan into atomic implementation tasks (run AFTER plan is accepted and open questions resolve)
- `lifecycle:sdd-apply` — only after tasks.md exists
