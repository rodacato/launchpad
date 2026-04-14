---
name: experts
description: Create or update docs/EXPERTS.md — the Expert Advisory Panel of AI personas the Build Identity consults. Use when the project needs domain perspectives beyond the Identity's scope. Use when onboarding a project that lacks specialist guidance. Use when decisions keep stalling for lack of clear domain authority. Use after IDENTITY.md is written and the expertise gaps become visible.
metadata:
  version: "1.2"
---

# Experts

## Overview

Create or update `docs/EXPERTS.md` — the Expert Advisory Panel. Specialized AI
personas that provide domain-specific guidance. The Build Identity consults
this panel when a decision requires a perspective outside their day-to-day
scope. A useful panel has OPINIONS: experts without disagreements are just
a rubber stamp with more words.

## When to Use

- Project has IDENTITY.md but the Identity lacks expertise in obvious domains (security, UX, infra)
- Decisions keep going in circles for lack of authoritative domain perspective
- Team wants a consistent "who should we ask about X?" routing mechanism
- Onboarding a project where specialist judgment is needed but no specialists exist
- EXPERTS.md exists but feels generic — experts could belong to any project

**When NOT to use:**
- Project has no IDENTITY.md yet — run `identity` first; panel complements the Identity
- Throwaway scripts or spikes that won't need ongoing specialist consultation
- Solo projects where the single human IS the expert across all domains

## Before you start

Locate and read these files if present — they shape who belongs on the panel:

- `VISION.md` — domain, stack, biggest risks (who do we need to defend against what?)
- `IDENTITY.md` — the Build Identity's expertise gaps (experts fill these)
- `ARCHITECTURE.md` — stack specifics that inform technical experts

```bash
fd VISION.md --exclude .git
fd IDENTITY.md --exclude .git
fd ARCHITECTURE.md --exclude .git
```

If none exist, you'll be sourcing everything from the human in Step 1.

## Process

### If EXPERTS.md does NOT exist — Create

#### Step 1 — Understand what the project needs

Before proposing experts, read every available file from the list above.
Summarize back to the human what you found: domain, stack, risks, Identity
gaps. If nothing exists, ask:
- "What does this project do? What's the domain?"
- "What's the stack?"
- "What are the biggest risks or unknowns?"
- "Where does the Identity feel out of their depth?"

#### Step 2 — Propose the panel composition

Tell the human: "Based on what I know, here are the perspectives I think you
need on the panel. What would you add, remove, or change?"

Default experts most projects need (adapt to the domain):
- **Product Strategy** — scope, prioritization, user lens
- **Software Architecture** — system design, domain modeling, patterns
- **Security** — auth, threat modeling, data protection
- **UX/Design** — user experience, accessibility, interface design

Domain-specific experts to consider:
- **Infrastructure/DevOps** — if self-hosted, complex deploys, SRE concerns
- **AI/LLM** — if the project integrates language models
- **Growth/GTM** — if the project needs launch strategy or community building
- **Domain Expert** — industry-specific (fintech, healthcare, education)
- **Content/Learning** — if educational content or documentation heavy
- **QA/Testing** — non-deterministic outputs or complex test strategies

Split the panel into:
- **CORE** (5-7 experts) — consulted regularly across all phases
- **SITUATIONAL** (2-4 experts) — consulted at specific phases or decisions

#### Step 3 — Build each expert profile

For each expert, ask the human enough to make the profile SPECIFIC to this
project. A good expert profile has:
- A name and backstory that feels real (specific > generic)
- Skills tied to THIS project's actual challenges (not a generic resume)
- Clear "when to consult" triggers
- A distinct communication style with example sentences
- **Opinions** — experts without opinions are useless

Show each expert to the human for approval before moving to the next.

#### Step 4 — Build routing and conflict rules

Once all experts are defined:
- Create the Quick Reference table
- Create the Decision Routing table (domain → which expert)
- Define conflict resolution: **the Identity always makes the final call**,
  but must cite which experts they consulted and where they disagreed

Use the template at `skills/experts/template.md` as the structure guide.
Show the full draft to the human for approval before writing the file.

### If EXPERTS.md already exists — Update

1. Locate the file: `fd EXPERTS.md --exclude .git`
2. Read the current content end-to-end
3. Read `skills/experts/template.md` for new sections or structure improvements
4. Compare: what sections exist in the template that the current file lacks?
5. Propose the diff to the human
6. Merge approved changes — **preserve ALL existing expert profiles verbatim**;
   only add, never overwrite a persona's voice

## Consultation flow (how the panel is USED)

This skill PRODUCES the panel. Once written, the panel is consulted as follows:

1. Identity encounters a decision outside their scope
2. Identity scans the Decision Routing table → picks relevant expert(s)
3. Identity invokes each expert persona, gets their position
4. If experts disagree, Identity surfaces the disagreement to the human with tradeoffs
5. Identity makes the final call, citing which experts were consulted

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "We don't need experts — the Identity knows enough" | The Identity is ONE persona with bounded expertise. If they could cover security, UX, and infra too, they'd be four people. The panel acknowledges that reality. |
| "The experts will just agree with whatever the Identity says" | Only if you build them that way. Each expert MUST have opinions that can contradict the Identity — otherwise the panel is theater. |
| "Let's just use generic expert templates" | A generic 'Security Expert' has no idea about YOUR threat model. Specific > generic, always. The profile must know this project's stack and risks. |
| "Routing table is overkill, we'll figure out who to ask" | Without routing, the Identity defaults to consulting nobody or consulting everybody. Both fail. Explicit routing produces consistent decisions. |
| "I'll skip conflict resolution rules — they'll just agree" | They won't. The first time Security and UX disagree about auth UX, you need a pre-agreed rule for who breaks the tie. |
| "Panel composition can wait — we'll add experts as we need them" | The value of the panel is in being consultable BEFORE the decision. Assembling experts mid-decision biases the selection toward confirming what you already want. |

## Red Flags

- Expert profiles without opinions — every recommendation ends in "it depends"
- Experts with generic skills lists that could apply to any project
- No Decision Routing table, or the routing is vague ("consult the appropriate expert")
- No conflict resolution rule — who wins when experts disagree?
- Expert backstories are blanks or one-liners (Name: Security Expert. Skills: Security.)
- No CORE vs SITUATIONAL split — treating all experts equally dilutes routing
- Expert count > 12 — panel is too large to be consultable
- No example consultations or sample dialogues showing the persona's voice

## Verification

- [ ] `docs/EXPERTS.md` exists
- [ ] Panel is split into CORE (5-7) and SITUATIONAL (2-4) sections
- [ ] Every expert has: name, backstory, skills tied to THIS project, triggers, example sentences
- [ ] At least 3 experts have opinions that could contradict the Identity or another expert
- [ ] Quick Reference table lists all experts with one-line "consult for" summaries
- [ ] Decision Routing table maps at least 5 common domains to specific experts
- [ ] Conflict resolution rule is explicit: Identity makes the final call and cites which experts were consulted
- [ ] No generic placeholder skills ("problem-solving", "communication") — all skills are project-specific
- [ ] Read aloud: each expert sounds like a DIFFERENT person, not the same voice with different hats
- [ ] `.launchpad/manifest.yml` updated with `experts: "1.2"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `experts: "1.2"` under `modules:`.

Next likely skills:
- `identity` — if not already established, write the Identity that CONSULTS this panel
- `architecture` — technical experts on the panel inform how this gets written
- `workflow` — bake expert consultation triggers into the team's daily process
