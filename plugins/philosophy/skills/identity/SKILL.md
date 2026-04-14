---
name: identity
description: Create or update IDENTITY.md — the Build Identity, technical persona for the project
metadata:
  version: "1.1"
  author: rodacato
  triggers:
    - identity
    - "build identity"
    - "IDENTITY.md"
    - "technical persona"
---

# Identity

Create or update `docs/IDENTITY.md` — the Build Identity. The technical persona the agent
embodies when working on this project. Not the human — the ideal fractional CTO / staff
engineer whose judgment best serves this project's success.

## Before you start

Search for these files by name:
- `VISION.md` — read it first. The identity must serve the vision.
- `ARCHITECTURE.md` — if it exists, the identity should reflect the stack expertise

Use: `find . -name "VISION.md" -not -path "*/.git/*"`

---

## If IDENTITY.md does NOT exist — Create

### Step 1 — Understand the project context
Read VISION.md and any available architecture docs.
Summarize what kind of technical leader would best serve this project.

### Step 2 — Discovery conversation
Ask the human:

About the persona:
- "What kind of technical leader does this project need? A systems thinker?
   A product-minded engineer? A security-first architect?"
- "What industry experience should this person have?"
- "What's the vibe — measured and precise, or energetic and opinionated?"

About technical judgment:
- "When there are two valid approaches, what should the tiebreaker be?
   Simplicity? Performance? Developer experience? Deletability?"
- "What technical anti-patterns should this persona actively reject?"
- "What quality bar is non-negotiable?"

About communication:
- "How should this persona communicate? Direct and terse? Explanatory? Mentoring?"
- "Give me an example of how they'd push back on scope creep."

### Step 3 — Draft and iterate
Write the full identity using the template at `skills/identity/template.md`.
Make it feel like a REAL person — with opinions, a backstory, and a clear
decision-making framework. Not a generic checklist.

Show it to the human. Refine until approved.

---

## If IDENTITY.md already exists — Update

1. Find the file: `find . -name "IDENTITY.md" -not -path "*/.git/*"`
2. Read the current content
3. Read the template at `skills/identity/template.md` for new sections
4. Identify sections that are missing or that could benefit from improvement
5. Update with approved changes, preserving the full persona as established

---

## When done

Update `.launchpad/manifest.yml` — set `identity: "1.1"` under `modules:`.
