---
name: roadmap
description: Create or update ROADMAP.md — phases, what's built, what's next, not doing, decision log
metadata:
  version: "1.1"
  author: rodacato
  triggers:
    - roadmap
    - "ROADMAP.md"
    - "project phases"
    - "what's next"
---

# Roadmap

Create or update `docs/ROADMAP.md` — the living map: phases, what's been built, what's next,
what we're NOT doing. The agent reads this to know project status at any moment.

## Before you start

Search for these files by name:
- `VISION.md` — execution strategy and litmus test live here
- `ARCHITECTURE.md` — tech stack context

Use: `find . -name "VISION.md" -not -path "*/.git/*"`

---

## If ROADMAP.md does NOT exist — Create

### Step 1 — Intent and phases
Ask:
- "What's the end goal for v1? When do you know the project 'works'?"
- "What needs to exist before anything else? That's Phase 0."
- "What makes the project usable for YOU? That's Phase 1."
- "What makes it usable for OTHERS? That's the next phase."

Each phase needs: a goal (one sentence), a "done when" criterion (observable, binary),
and what DOES NOT start until this phase is in real use.

### Step 2 — What's next (initial features)
Ask:
- "What are the first 3-5 things you want to build?"
- "What's the priority order? What's the effort size (S/M/L)?"

### Step 3 — Not doing
Based on VISION.md's "What This Is NOT":
- "What features will people request that you'll say no to?"
- "What's the reasoning, and under what conditions would you revisit?"

This section prevents scope creep. NEVER delete from it — if revisited, update reasoning.

### Step 4 — Prioritization principles
Ask: "When two features compete for your time, how do you decide?"
3-5 tiebreaker rules.

Use the template at `skills/roadmap/template.md` as structure.
History tables (specs, decisions) start empty — they fill as work happens.

---

## If ROADMAP.md already exists — Update

1. Find the file: `find . -name "ROADMAP.md" -not -path "*/.git/*"`
2. Read the current content
3. Read the template at `skills/roadmap/template.md` for new sections
4. Common improvements to check for: missing phases, outdated "Currently working on",
   items in "What's Next" that should move to "What's Been Built"
5. Update with approved changes, preserving decision log and history tables

---

## When done

Update `.launchpad/manifest.yml` — set `roadmap: "1.1"` under `modules:`.
