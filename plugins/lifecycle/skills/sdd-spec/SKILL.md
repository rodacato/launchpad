---
name: sdd-spec
description: SDD-lite step 1 — writes docs/sdd/<change-name>/spec.md describing WHAT we're building, WHY, and how we'll know it's done. The first artifact in the spec → plan → tasks → apply → verify chain. Use when starting a substantial change worth structured planning. Use when a feature has unclear scope or success criteria. Use when stakeholders disagree about what "done" looks like. NOT for trivial fixes — those don't earn the SDD ceremony.
metadata:
  version: "0.1"
---

# SDD Spec

## Overview

Step 1 of SDD-lite. Writes `docs/sdd/<change-name>/spec.md` — the
specification for a substantial change. Captures WHAT (the change), WHY
(the motivation), and HOW WE'LL KNOW (success criteria) before any design
or implementation thinking starts.

A spec is a forcing function: if you can't write it, you don't yet
understand the change well enough to design it. That ambiguity is the
information the spec captures.

## When to Use

- A change is large enough that "just do it" loses critical context (multiple files, multiple sessions, multiple stakeholders)
- Scope is fuzzy and the team would benefit from naming what's IN and what's OUT
- Stakeholders are likely to disagree about what "done" means
- The change touches a sensitive area (auth, billing, data migrations) where a misalignment is expensive
- Onboarding someone new to drive the change — the spec is what they read first

**When NOT to use:**
- Trivial fix (typo, lint, single-file refactor) — write a commit message instead
- Exploratory spike where the WHAT is the open question — that's research, not a spec
- Someone else's spec already exists (an issue, a PRD, an RFC) — link it, don't rewrite it

## Before you start

Required: a one-line description of the change from the human ("what are we
building?"). Without that, ask before doing anything else.

Read for context if present:

```bash
fd VISION.md docs --exclude .git
fd ARCHITECTURE.md docs --exclude .git
fd ROADMAP.md docs --exclude .git
fd IDENTITY.md docs --exclude .git
```

These shape WHY the change matters and what tradeoffs the project would
naturally accept.

Pick the change name (kebab-case, short, descriptive). It becomes the
folder name: `docs/sdd/<change-name>/`. Confirm with the human before
creating the folder.

## Process

### Step 1 — Discovery conversation

Ask the human in this order. Write the answers down as you go.

**WHAT (scope)**
- "What's the change in one sentence?"
- "What are the IN-scope items? List them."
- "What are the OUT-of-scope items? Equally important — name them so we don't smuggle them in."
- "What's the smallest version of this that delivers value?"

**WHY (motivation)**
- "What problem does this solve?"
- "Who feels the problem today, and how often?"
- "What happens if we don't do this?"
- "How does this connect to VISION / ROADMAP / a known incident?"

**HOW WE'LL KNOW (success criteria)**
- "When this change is done, what observable thing is true that wasn't before?"
- "What metric / behavior / test confirms success?"
- "What would a reviewer specifically look for to approve this?"

If the human can't answer WHAT or HOW WE'LL KNOW: STOP. The spec isn't
ready. Either dig deeper with them or pause and recommend an exploratory
spike first.

### Step 2 — Draft the spec

Create `docs/sdd/<change-name>/spec.md` with the structure below. Fill
EVERY section — empty sections mean unresolved ambiguity that will surface
later as rework.

```markdown
# Spec — <change-name>

> Step 1 of SDD-lite. Status: draft | accepted | shipped

## Summary

One paragraph. WHAT is changing, WHY, and the headline of HOW we'll know.

## In scope

- bullet
- bullet

## Out of scope

- bullet (with one-line rationale)
- bullet

## Motivation

WHY this change. Who feels the problem; how often. Link to incident, issue,
or roadmap entry if applicable.

## Success criteria

- [ ] Observable / measurable thing true after the change
- [ ] Specific test / metric / behavior that confirms it
- [ ] What a reviewer looks for

## Constraints

Hard constraints the design must respect (perf, security, compatibility,
deadline, team agreements).

## Open questions

Things that need answers before sdd-plan starts. Each question has an
owner (human or "me") and a deadline.

| Q | Owner | Needed by |
|---|---|---|
| ... | ... | ... |

## References

- Issue: #<N> (if any)
- Related docs: ...
- Prior art (in this codebase or elsewhere): ...
```

### Step 3 — Show the draft + iterate

Share the draft with the human. Iterate until they accept it. Lock the
status to `accepted` only when they explicitly approve — don't auto-promote.

### Step 4 — Write the file

Create `docs/sdd/<change-name>/` if it doesn't exist. Write `spec.md`.
Commit it on its own (per the lifecycle:git-workflow conventions); the
commit message is `docs(sdd): add spec for <change-name>`.

### Step 5 — Hand off

Tell the human:

```
Spec written: docs/sdd/<change-name>/spec.md (status: accepted)
Open questions: <count>
Next step: /lifecycle:sdd-plan <change-name>  (after open questions resolve)
```

Do NOT auto-run sdd-plan. The human drives the transition.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I know what we're building, I'll skip the spec" | If the next person on this change can't be onboarded by reading the spec in 5 minutes, the spec was needed. Knowing WHAT in your head is not the same as writing it down where others can see it. |
| "Out-of-scope is obvious, I won't list it" | OUT-of-scope is where scope creep enters. Writing it down is the gate that catches "while we're at it" additions during apply. |
| "Success criteria are 'it works'" | "It works" can mean five different things. Enumerate the observable conditions. If you can't, you don't have testable criteria — you have a wish. |
| "Open questions can wait until plan" | Open questions surfaced now cost a paragraph. Surfaced in plan, they cost a redesign. Surfaced in apply, they cost the implementation. Cheaper to ask now. |
| "I'll write the spec AFTER I prototype" | The spec exists to keep the prototype honest. Writing it after means the prototype's choices become the spec — and any unexplored alternative is dead before discussion. |
| "This is too small for SDD" | Maybe. The When-NOT-to-use list is for that. If the change touches >2 files or >1 session, the spec usually pays for itself. |

## Red Flags

- `spec.md` has empty sections — the implicit ambiguity will surface later as rework
- "Success criteria" bullets are vague ("works correctly", "is intuitive") instead of observable
- "Out of scope" is empty — almost always means scope creep is incoming
- Open questions exist but the spec status was set to `accepted` anyway
- The spec was written without consulting VISION / ROADMAP when those exist
- The change name is generic (`update-auth`, `improvements`) instead of descriptive
- Spec was auto-written without the discovery conversation in Step 1 — that's a wishlist, not a spec

## Verification

- [ ] `docs/sdd/<change-name>/` directory exists with `spec.md` inside
- [ ] Every template section is filled (no `TODO` or empty bullets) OR explicitly marked "N/A — <reason>"
- [ ] Status field reflects reality: `draft` while open questions remain, `accepted` only after human approval
- [ ] Success criteria are checkable — a reviewer can read them and run the check
- [ ] Out-of-scope list is non-empty and each entry has a one-line rationale
- [ ] Open questions table has owners and deadlines (not just questions)
- [ ] Existing VISION / ROADMAP / ARCHITECTURE were consulted if present
- [ ] Commit landed with `docs(sdd): add spec for <change-name>`

## When done

Nothing to update in `.launchpad/manifest.yml` — sdd-spec is a lifecycle
skill and produces a workflow artifact (spec.md), not a project artifact.

Next likely skills:
- `lifecycle:sdd-plan` — design the solution that satisfies this spec (run AFTER open questions resolve and the human marks the spec accepted)
- `lifecycle:sdd-tasks` — only after sdd-plan has produced plan.md
