---
name: experts
description: Create or update EXPERTS.md — expert advisory panel of AI personas
metadata:
  version: "1.1"
  author: rodacato
  triggers:
    - experts
    - "expert panel"
    - "EXPERTS.md"
    - "advisory panel"
---

# Experts

Create or update `docs/EXPERTS.md` — Expert Advisory Panel. Specialized AI personas that
provide domain-specific guidance. The Build Identity consults this panel when a decision
requires a perspective outside their day-to-day scope.

## Before you start

Search for these files by name (they may be anywhere in the project):
- `VISION.md` — read it to understand domain, stack, and biggest risks
- `IDENTITY.md` — read it to know the Build Identity's expertise gaps
- `ARCHITECTURE.md` — read it if it exists (stack context for expert selection)

Use: `find . -name "VISION.md" -not -path "*/.git/*"` to locate them.

---

## If EXPERTS.md does NOT exist — Create

### Step 1 — Understand what the project needs

Before proposing experts, read any available files from the list above.
Summarize back to the human what you found. If nothing exists, ask:
- "What does this project do? What's the domain?"
- "What's the stack?"
- "What are the biggest risks or unknowns?"

### Step 2 — Propose the panel composition

Tell the human: "Based on what I know, here are the perspectives I think you need
on the panel. What would you add, remove, or change?"

Default experts most projects need (adapt to the domain):
- Product Strategy — scope, prioritization, user lens
- Software Architecture — system design, domain modeling, patterns
- Security — auth, threat modeling, data protection
- UX/Design — user experience, accessibility, interface design

Domain-specific experts to consider:
- Infrastructure/DevOps — if self-hosted, complex deploys, or SRE concerns
- AI/LLM — if the project integrates language models
- Growth/GTM — if the project needs launch strategy or community building
- Domain Expert — industry-specific knowledge (fintech, healthcare, education, etc.)
- Content/Learning — if the project involves educational content or documentation
- QA/Testing — if non-deterministic outputs or complex test strategies

Split into:
- CORE panel (5-7 experts) — consulted regularly throughout all phases
- SITUATIONAL panel (2-4 experts) — consulted at specific phases or decisions

### Step 3 — Build each expert profile

For each expert, ask the human enough to make the profile SPECIFIC to this project.
A good expert profile has:
- A name and backstory that feels real (specific > generic)
- Skills tied to THIS project's actual challenges (not a generic resume)
- Clear "when to consult" triggers
- A distinct communication style with example sentences
- Opinions — experts without opinions are useless

Show each expert to the human for approval before moving to the next.

### Step 4 — Build the routing table and conflict rules

Once all experts are defined:
- Create the Quick Reference table
- Create the Decision Routing table (domain → which expert)
- Define conflict resolution (the Identity always makes the final call)

Use the template at `skills/experts/template.md` as the structure guide.
Show it to the human for approval.

---

## If EXPERTS.md already exists — Update

1. Find the file: `find . -name "EXPERTS.md" -not -path "*/.git/*"`
2. Read the current content
3. Read the template at `skills/experts/template.md` for new sections
4. Compare: what sections/improvements are in the template that the current file lacks?
5. Merge approved changes, preserving ALL existing content — only add, never overwrite expert profiles

---

## When done

Update `.launchpad/manifest.yml` — set `experts: "1.1"` under `modules:`.
