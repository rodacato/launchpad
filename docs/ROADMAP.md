# Roadmap

> The living map of this project: where it came from, where it is, and where it's going.
> The agent reads this to know the project's status at any moment. Keep it updated.
>
> Ask the agent: "What are we working on?", "What's left?", "Did we ship X?",
> "What's next after this?" — this document has the answers.

---

<!-- AGENT INSTRUCTIONS — How to fill this document

This document evolves throughout the project's life. The initial version is built
during project setup, but it's UPDATED continuously as work progresses.

PREREQUISITES: Read these first if they exist:
  - docs/VISION.md — the philosophy, execution strategy, and litmus test
  - docs/ARCHITECTURE.md — the tech stack and system design

STEP 1 — Intent and Milestones
  Ask the human:
  - "What's the end goal for v1? When do you know the project 'works'?"
  - "What are the big milestones between now and there?"
  - "Are there dates, or is this driven by outcomes?"

  Each milestone should be defined by WHAT BECOMES POSSIBLE, not just a date.

STEP 2 — Phases
  Based on the vision's execution strategy, break down into phases.
  Ask:
  - "What needs to exist before anything else? That's Phase 0."
  - "What makes the project usable for YOU? That's Phase 1."
  - "What makes it usable for OTHERS? That's the next phase."
  - "What's the decision point where you evaluate opening up?"

  Each phase needs: a goal (one sentence), what "done" looks like,
  and what DOES NOT start until this phase is in real use.

STEP 3 — What's Next (initial features)
  Ask:
  - "What are the first 3-5 things you want to build?"
  - "What's the priority order? What's effort size (S/M/L)?"

  Create the initial "What's Next" table.

STEP 4 — Not Doing
  Based on VISION.md's "What This Is NOT" section:
  - "What features will people request that you'll say no to?"
  - "What's the reasoning, and under what conditions would you revisit?"

  This section prevents scope creep and documents WHY decisions were made.

STEP 5 — Prioritization Principles
  Ask:
  - "When two features compete for your time, how do you decide?"
  - "What's the #1 rule that overrides everything else?"

  3-5 principles that guide what gets built and in what order.

ONGOING MAINTENANCE:
  As work progresses, the agent should:
  - Move completed features from "What's Next" to "What's Been Built"
  - Add new specs/PRDs/ADRs to their respective history tables
  - Update sprint history when sprints close
  - Update "Currently working on" at the top
  - Move backlog items to "What's Next" when ready
  - NEVER delete from "Not Doing" — if revisited, update the reasoning

-->

**Intent:** <!-- One paragraph: why this project exists and what it's optimizing for.
     Not the full vision — the strategic focus that guides prioritization. -->

**Currently working on:** <!-- What's actively in progress right now. Update this often. -->

---

## Milestones

<!-- Define by WHAT BECOMES POSSIBLE, not just dates.
     Dates are optional — outcomes are not. -->

| Milestone | Goal | Phase |
|---|---|---|
| <!-- e.g. MVP --> | <!-- e.g. Creator can complete the core flow end-to-end in production --> | <!-- Phase 0 --> |
| <!-- e.g. Alpha --> | <!-- e.g. 3-5 invited users use it consistently and come back --> | <!-- Phase 1 --> |
| <!-- e.g. Beta --> | <!-- e.g. Content/features scale beyond the creator --> | <!-- Phase 2 --> |
| <!-- e.g. Launch decision --> | <!-- e.g. Evaluate: open to public, waitlist, or stay invite-only --> | <!-- Phase 3 --> |

---

## Phases

<!-- Each phase has a clear goal and a "does not start until" condition.
     No phase begins until the previous one is in real daily use. -->

### Phase 0 — <!-- Name -->

**Goal:** <!-- One sentence: what becomes possible when this phase is done? -->

<!-- 1-2 paragraphs: what this phase includes, what it explicitly excludes,
     and what "done" looks like. -->

### Phase 1 — <!-- Name -->

**Goal:** <!-- One sentence -->

<!-- Description. Does not start until Phase 0 is in real daily use. -->

### Phase 2 — <!-- Name -->

**Goal:** <!-- One sentence -->

<!-- Description -->

### Phase 3 — <!-- Name -->

**Goal:** <!-- One sentence -->

<!-- Description. This might be a decision point, not a build phase. -->

<!-- Add more phases as needed. Keep them focused. -->

---

## What's Been Built

<!-- Shipped and working. Updated as features complete.
     See CHANGELOG.md for full version history. -->

| Area | Capabilities | Since |
|------|-------------|-------|
| <!-- e.g. Auth --> | <!-- e.g. GitHub OAuth, sessions, password reset --> | <!-- e.g. v0.1 --> |

---

## What's Next

<!-- Features prioritized and ready to build.
     Move to "What's Been Built" when shipped. -->

| # | Feature | Summary | Priority | Effort | Status | Spec |
|---|---------|---------|----------|--------|--------|------|
| 1 | <!-- feature --> | <!-- summary --> | <!-- High/Medium/Low --> | <!-- S/M/L --> | <!-- backlog/in-progress --> | <!-- link or — --> |
| 2 | <!-- feature --> | <!-- summary --> | <!-- priority --> | <!-- effort --> | <!-- status --> | <!-- spec --> |

---

## Backlog

<!-- Ideas evaluated but not yet prioritized.
     When ready to build, write a spec and move to "What's Next". -->

| # | Feature | Summary | Intent | Effort |
|---|---------|---------|--------|--------|
| 1 | <!-- feature --> | <!-- summary --> | <!-- why this matters --> | <!-- S/M/L --> |

---

## Not Doing

<!-- Evaluated and decided AGAINST. Reasoning preserved.
     NEVER delete from this table — if revisited, update the reasoning.
     This is the anti-scope shield that prevents scope creep. -->

| Feature | Why not | Revisit if |
|---------|---------|------------|
| <!-- feature --> | <!-- reasoning --> | <!-- condition that would change the decision --> |

---

## History — Sprints

<!-- Updated as sprints close. Links to sprint docs if they exist. -->

| Sprint | Outcome | Status |
|---|---|---|
| <!-- sprint-001 — Name --> | <!-- what was delivered --> | <!-- ✅ Closed / 🔄 Active --> |

---

## History — Specs

<!-- Technical specs created during the project. Links to spec docs. -->

| # | Spec | Description | Sprint |
|---|---|---|---|
| <!-- 001 --> | <!-- spec name --> | <!-- summary --> | <!-- sprint --> |

---

## History — ADRs

<!-- Architecture Decision Records. Links to ADR docs.
     Also include smaller decisions that don't warrant a full ADR. -->

| # | ADR | Decision | Status |
|---|---|---|---|
| <!-- 001 --> | <!-- title --> | <!-- what was decided --> | <!-- ✅ Accepted --> |

**Other decisions not warranting a full ADR:**

| Decision | Chosen | Why |
|----------|--------|-----|
| <!-- decision --> | <!-- what --> | <!-- why --> |

---

## Prioritization Principles

<!-- 3-5 rules that guide what gets built and in what order.
     When two features compete, these are the tiebreaker. -->

1. <!-- e.g. Use it before building around it. No feature until the previous phase is in daily use. -->
2. <!-- e.g. The core loop comes first. Everything else is context. -->
3. <!-- e.g. Complexity is the enemy. If a feature makes the user think about the product instead of the work, it's wrong. -->
4. <!-- e.g. ... -->

---

## Sizing Key

| Size | Meaning |
|------|---------|
| S | Single PR, single layer |
| M | May touch multiple layers |
| L | New subsystem |

---

*Last updated: <!-- date -->*
