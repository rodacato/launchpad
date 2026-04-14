---
name: vision
description: Create or update docs/VISION.md — the project's compass (problem, philosophy, litmus test, what-this-is-NOT). Use when starting a new project. Use when the project direction feels unclear. Use when two features conflict and you need a tie-breaker. Use when onboarding someone and they ask "what IS this?"
metadata:
  version: "1.2"
  author: rodacato
  category: bootstrap
  triggers:
    - vision
    - "project vision"
    - "VISION.md"
    - "project compass"
    - "what is this project"
---

# Vision

## Overview

Create or update `docs/VISION.md` — the project's compass. Every feature
decision, every scope debate, every "should we build this?" gets filtered
through what's written here. This is the MOST IMPORTANT document in the
project — do not rush it.

A vision without opinion is useless. "We value quality" is not a vision;
"we ship rough edges before we ship feature bloat" is.

## When to Use

- Brand new project with no docs
- Project where contributors disagree on scope or priorities
- "Should we build X?" keeps coming up without a clear tiebreaker
- Before writing ROADMAP.md or ARCHITECTURE.md — vision comes first
- When VISION.md exists but feels generic, empty, or was written by someone
  else for a different project

**When NOT to use:**
- Vanity polish on an already-strong vision — don't fiddle for fiddle's sake
- When the user just wants a README — that's a different skill
- For one-off throwaway scripts or spikes that won't be maintained

## Before you start

No hard prerequisites. If `CLAUDE.md` exists, read it for any already-captured
identity cues. If there's an existing README, skim it — the user may already
have articulated parts of the vision there without calling it that.

## Process

### If VISION.md does NOT exist — Create

This is an exploration. Your job is to ask the RIGHT questions, not fill blanks.
Go section by section, in this order:

#### Step 1 — The Problem
Ask:
- "What frustrates you about the way things work today?"
- "What's the gap you keep running into that nothing solves well?"
- "How are people currently dealing with this? What's broken about those solutions?"

Dig deeper: if the answer is vague, ask for a specific scenario.
The problem should feel REAL and SPECIFIC — a lived frustration.

#### Step 2 — The Insight
Ask:
- "What do you see about this problem that others might be missing?"
- "Is there an existing tool that gets 80% right? What's the missing 20%?"

#### Step 3 — The Philosophy
Ask:
- "When two features conflict, how do you decide which one wins?"
- "What would you NEVER compromise on, even under pressure?"
- "What's the tone? Playful? Serious? Opinionated? Neutral?"

Good philosophies are OPINIONATED. "We value quality" is useless.

#### Step 4 — Who It's For
Ask:
- "Who is the first person who will use this besides you?"
- "Who is this explicitly NOT for?"

#### Step 5 — What Success Looks Like
Ask:
- "If this project succeeds beyond your expectations, what does that look like?"
- "Is this about users? Revenue? Personal learning? A combination?"

#### Step 6 — What This Is NOT
Ask:
- "What will people assume this does that it shouldn't?"
- "What features sound cool but would dilute the core?"

#### Step 7 — The Litmus Test
Propose 3-5 yes/no questions based on the conversation that filter every future feature.
Refine with the human.

#### Step 8 — Draft and iterate
Write the full vision using the template at `skills/vision/template.md`.
Show it to the human. The test: does it make you FEEL something? If not, it's not done.

Wait for approval before writing the file.

### If VISION.md already exists — Update

1. Find the file: `fd VISION.md --exclude .git` (or `find . -name "VISION.md" -not -path "*/.git/*"`)
2. Read the current content
3. Read the template at `skills/vision/template.md` for new sections
4. Show the human what sections could be added or improved
5. Update with approved changes, preserving all existing content

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "We can write this later once we know what we're building" | Without vision, every later decision is a coin flip. The vision shapes what you build — not the other way around. |
| "Our vision is 'make X better'" | That's not a vision, that's a slogan. Vision names the specific gap, the specific audience, and what you'd refuse to do. |
| "Let's skip the 'What This Is NOT' — it sounds negative" | The NOT section is where the vision earns its strength. Without it, scope creep has no brake. |
| "The litmus test feels too constraining" | That's the point. A vision that can't reject features isn't pulling its weight. |
| "I'll just copy a vision from another project" | A borrowed vision can't make you FEEL anything and won't resolve disputes. Write your own, even if shorter. |

## Red Flags

- Vision reads like a marketing page — lots of adjectives, no concrete "what" or "for whom"
- No "What This Is NOT" section, or it's empty
- Philosophy section has zero sentences starting with "We would rather..." or "We refuse to..."
- Litmus test has more than 7 questions (too permissive) or fewer than 3 (too sparse)
- No concrete problem scenario — only abstract claims about "efficiency" or "quality"
- Vision written without a conversation — drafted by someone reading a template and filling blanks

## Verification

- [ ] `docs/VISION.md` exists at the project root
- [ ] Problem section names a specific, lived frustration (not a generic industry complaint)
- [ ] Philosophy section contains at least one OPINIONATED stance (e.g. "we would rather X than Y")
- [ ] "Who This Is NOT For" explicitly lists at least one excluded audience
- [ ] "What This Is NOT" lists at least 3 things this project refuses to become
- [ ] Litmus Test has 3-5 yes/no questions that could actually reject a feature
- [ ] When read aloud to the human, the vision makes them feel something — approve or wince, not neutral
- [ ] `.launchpad/manifest.yml` updated with `vision: "1.2"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `vision: "1.2"` under `modules:`.

Next likely skills:
- `roadmap` — translate vision into a timeline and milestones
- `identity` — codify how the team works based on the vision's philosophy
- `architecture` — design the system around what the vision says matters
