---
name: roadmap
description: Create or update docs/ROADMAP.md — phases, what's built, what's next, what we're NOT doing, decision log. Use when starting a new project after vision is set. Use when the team disagrees on what to build next. Use when stakeholders keep asking "is X on the roadmap?". Use when scope is creeping and you need an explicit "not doing" list.
metadata:
  version: "1.2"
---

# Roadmap

## Overview

Create or update `docs/ROADMAP.md` — the living map of the project: phases, what's been built, what's next, and what we're explicitly NOT doing. This is the document the agent (and the humans) read to know where the project stands at any moment and what the next move is. A roadmap without a "not doing" section is a wish list.

## When to Use

- A new project has a VISION.md but no ordered plan yet
- Multiple features are competing and there's no clear tie-breaker on sequence
- The team is losing track of what's been shipped versus what's still open
- Requests keep arriving for features that dilute the core — you need something to point at
- An existing ROADMAP is stale (phases done but not marked, "What's Next" full of shipped work)

**When NOT to use:**
- Before VISION.md exists — the roadmap needs the vision's litmus test to sequence phases
- For a throwaway spike or experimental branch that won't be maintained
- As a substitute for issue tracking — the roadmap is phases and themes, not the task board

## Before you start

Search for these files by name:
- `VISION.md` — execution strategy, audience, and litmus test live here
- `ARCHITECTURE.md` — tech stack context (informs effort sizing)

Use: `fd VISION.md --exclude .git` (or `find . -name "VISION.md" -not -path "*/.git/*"`)

If VISION.md is missing, stop and run the `vision` skill first. Roadmap without vision produces a feature list, not a strategy.

## Process

### If ROADMAP.md does NOT exist — Create

#### Step 1 — Intent and phases
Ask:
- "What's the end goal for v1? When do you know the project 'works'?"
- "What needs to exist before anything else? That's Phase 0."
- "What makes the project usable for YOU? That's Phase 1."
- "What makes it usable for OTHERS? That's the next phase."

Each phase needs: a goal (one sentence), a "done when" criterion (observable, binary),
and what DOES NOT start until this phase is in real use.

#### Step 2 — What's next (initial features)
Ask:
- "What are the first 3-5 things you want to build?"
- "What's the priority order? What's the effort size (S/M/L)?"

#### Step 3 — Not doing
Based on VISION.md's "What This Is NOT":
- "What features will people request that you'll say no to?"
- "What's the reasoning, and under what conditions would you revisit?"

This section prevents scope creep. NEVER delete from it — if revisited, update reasoning.

#### Step 4 — Prioritization principles
Ask: "When two features compete for your time, how do you decide?"
3-5 tiebreaker rules.

Use the template at `skills/roadmap/template.md` as structure.
History tables (specs, decisions) start empty — they fill as work happens.

### If ROADMAP.md already exists — Update

1. Find the file: `fd ROADMAP.md --exclude .git` (or `find . -name "ROADMAP.md" -not -path "*/.git/*"`)
2. Read the current content
3. Read the template at `skills/roadmap/template.md` for new sections
4. Common improvements to check for: missing phases, outdated "Currently working on",
   items in "What's Next" that should move to "What's Been Built"
5. Update with approved changes, preserving decision log and history tables

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "We'll just track everything in GitHub issues" | Issues are the WHAT for this sprint; the roadmap is the WHY and in what order. Without phases, every issue looks equally important. |
| "Phases feel too waterfall — we're agile" | Phases are not Gantt charts. They're "we don't start X until Y is in real use." That's a discipline, not a schedule. |
| "We don't need a 'Not Doing' section, we'll just say no when asked" | Saying no repeatedly costs energy. Pointing at a written "not doing" with reasoning costs none. |
| "Effort sizes (S/M/L) are arbitrary, let's skip them" | They're calibration signals, not estimates. If every feature is L, the scope is wrong — that's the value. |
| "The decision log is overkill for our team" | Six months from now you will ask "why did we pick X?" and the answer will be gone. Log it or relive the debate. |

## Red Flags

- "Not Doing" section is empty or missing
- Every item in "What's Next" is priority "high" — no tie-breaker applied
- Phases have no observable "done when" criterion (e.g. "Phase 1: foundations" with no exit condition)
- Items sit in "Currently working on" for more than one sprint with no update
- "What's Been Built" contradicts reality — shipped features still listed under "What's Next"
- Decision log is empty months into the project — decisions are being made but not recorded
- Prioritization principles are generic ("we prioritize value") instead of opinionated ("users over contributors this quarter")

## Verification

- [ ] `docs/ROADMAP.md` exists at the project root
- [ ] At least 2 phases defined, each with a one-sentence goal AND an observable "done when"
- [ ] "What's Next" has effort sizes (S/M/L) on every item
- [ ] "Not Doing" section lists at least 3 items with reasoning and revisit conditions
- [ ] Prioritization principles section contains 3-5 tiebreaker rules, not platitudes
- [ ] Decision log exists (even if empty) with a clear template row
- [ ] Phase sequencing is consistent with VISION.md's litmus test — no phase violates the vision
- [ ] `.launchpad/manifest.yml` updated with `roadmap: "1.2"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `roadmap: "1.2"` under `modules:`.

Next likely skills:
- `architecture` — design the system that can actually deliver Phase 1
- `workflow` — define how issues, branches, and PRs flow into the phases
- `agents` — configure agent startup behavior to read ROADMAP.md for sprint context
