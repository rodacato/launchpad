# Module: roadmap

## What this installs

`docs/ROADMAP.md` — The living map: phases, milestones, what's been built,
what's next, what we're NOT doing. The agent reads this to know project status
at any moment. Updated continuously as work progresses.

## Before you start

Search for these files by name:
- `VISION.md` — execution strategy and litmus test live here
- `ARCHITECTURE.md` — tech stack context

Use: `find . -name "VISION.md" -not -path "*/.git/*"`

---

## If ROADMAP.md does NOT exist — Create

### Step 1 — Intent and milestones
Ask:
- "What's the end goal for v1? When do you know the project 'works'?"
- "What are the big milestones between now and there?"
- "Are there dates, or is this driven by outcomes?"

Each milestone should be defined by WHAT BECOMES POSSIBLE, not just a date.

### Step 2 — Phases
Ask:
- "What needs to exist before anything else? That's Phase 0."
- "What makes the project usable for YOU? That's Phase 1."
- "What makes it usable for OTHERS? That's the next phase."

Each phase needs: a goal (one sentence), what "done" looks like,
and what DOES NOT start until this phase is in real use.

### Step 3 — What's next (initial features)
Ask:
- "What are the first 3-5 things you want to build?"
- "What's the priority order? What's the effort size (S/M/L)?"

### Step 4 — Not doing
Based on VISION.md's "What This Is NOT":
- "What features will people request that you'll say no to?"
- "What's the reasoning, and under what conditions would you revisit?"

This section prevents scope creep. NEVER delete from it — if revisited, update reasoning.

### Step 5 — Prioritization principles
Ask: "When two features compete for your time, how do you decide?"
3-5 tiebreaker rules.

Use the template at `modules/roadmap/template.md` as structure.
History tables (sprints, specs, ADRs) start empty — they fill as work happens.

---

## If ROADMAP.md already exists — Update

1. Find the file: `find . -name "ROADMAP.md" -not -path "*/.git/*"`
2. Read the current content
3. Check the template for new sections:
   `https://raw.githubusercontent.com/rodacato/launchpad/master/modules/roadmap/template.md`
4. Common improvements to check for: missing phases, outdated "Currently working on",
   items in "What's Next" that should be moved to "What's Been Built"
5. Update with approved changes, preserving decision log and history tables

---

## When done

Update `.launchpad/manifest.yml`:
- Add `roadmap: "1.0"` under `modules:`

Then delete `LAUNCHPAD_TASK.md`.
