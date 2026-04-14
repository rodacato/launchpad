---
name: vision
description: Create or update VISION.md — project compass, problem, philosophy, litmus test
metadata:
  version: "1.1"
  author: rodacato
  triggers:
    - vision
    - "project vision"
    - "VISION.md"
    - "project compass"
---

# Vision

Create or update `docs/VISION.md` — the project's compass. Every feature decision, every
scope debate, every "should we build this?" gets filtered through what's written here.
This is the MOST IMPORTANT document in the project — do not rush it.

## Before you start

No prerequisites — this is usually the first skill. If `CLAUDE.md` exists,
read it for any already-captured identity.

---

## If VISION.md does NOT exist — Create

This is an exploration. Your job is to ask the RIGHT questions, not fill blanks.
Go section by section, in this order:

### Step 1 — The Problem
Ask:
- "What frustrates you about the way things work today?"
- "What's the gap you keep running into that nothing solves well?"
- "How are people currently dealing with this? What's broken about those solutions?"

Dig deeper: if the answer is vague, ask for a specific scenario.
The problem should feel REAL and SPECIFIC — a lived frustration.

### Step 2 — The Insight
Ask:
- "What do you see about this problem that others might be missing?"
- "Is there an existing tool that gets 80% right? What's the missing 20%?"

### Step 3 — The Philosophy
Ask:
- "When two features conflict, how do you decide which one wins?"
- "What would you NEVER compromise on, even under pressure?"
- "What's the tone? Playful? Serious? Opinionated? Neutral?"

Good philosophies are OPINIONATED. "We value quality" is useless.

### Step 4 — Who It's For
Ask:
- "Who is the first person who will use this besides you?"
- "Who is this explicitly NOT for?"

### Step 5 — What Success Looks Like
Ask:
- "If this project succeeds beyond your expectations, what does that look like?"
- "Is this about users? Revenue? Personal learning? A combination?"

### Step 6 — What This Is NOT
Ask:
- "What will people assume this does that it shouldn't?"
- "What features sound cool but would dilute the core?"

### Step 7 — The Litmus Test
Propose 3-5 yes/no questions based on the conversation that filter every future feature.
Refine with the human.

### Step 8 — Draft and iterate
Write the full vision using the template at `skills/vision/template.md`.
Show it to the human. The test: does it make you FEEL something? If not, it's not done.

Wait for approval before writing the file.

---

## If VISION.md already exists — Update

1. Find the file: `find . -name "VISION.md" -not -path "*/.git/*"`
2. Read the current content
3. Read the template at `skills/vision/template.md` for new sections
4. Show the human what sections could be added or improved
5. Update with approved changes, preserving all existing content

---

## When done

Update `.launchpad/manifest.yml` — set `vision: "1.1"` under `modules:`.
