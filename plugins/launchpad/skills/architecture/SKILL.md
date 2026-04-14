---
name: architecture
description: Create or update docs/ARCHITECTURE.md — system design, tech stack, domain model, directory layout, and key decisions with reasoning. Use when starting a new project with no technical design yet. Use when tech stack debates keep reopening. Use when a new contributor needs to understand the system without reading code. Use when architecture decisions are being made but not written down.
metadata:
  version: "1.1"
---

# Architecture

## Overview

Create or update `docs/ARCHITECTURE.md` — the blueprint someone reads to understand the ENTIRE system without looking at a single line of code. Tech stack, architecture style, domain model, directory layout, and every non-obvious decision with its rejected alternatives live here.

The test: a new engineer reads this, and can tell you where a new feature would live and why — without opening the repo.

## When to Use

- A new project has VISION.md but no technical design yet
- The team keeps relitigating the same stack or structure decisions
- Onboarding new contributors — they ask "why is it laid out this way?" and nobody has the answer written down
- A significant architectural change is proposed and there's no record of why the current design was chosen
- ARCHITECTURE.md exists but is a skeleton — sections without reasoning, no rejected alternatives documented

**When NOT to use:**
- Before VISION.md exists — architecture without a vision is premature optimization
- For a one-off script or spike with no domain model
- When what's actually needed is a README or a runbook, not a system blueprint

## Before you start

Search for these files by name (they inform architecture decisions):
- `VISION.md` — architecture principles and litmus test live here
- `IDENTITY.md` — the Build Identity's stack expertise and decision style
- `EXPERTS.md` — consult the Architect, Security, and Infrastructure experts here

Use: `fd VISION.md --exclude .git` (or `find . -name "VISION.md" -not -path "*/.git/*"`)

If VISION.md is missing, stop and run the `vision` skill first. Architecture without vision defaults to "whatever the last project used."

## Process

### If ARCHITECTURE.md does NOT exist — Create

The architecture is built through guided decisions. For each major choice:
1. Present the decision and the options
2. Consult the relevant experts (adopt their voice, give their perspective)
3. Show tradeoffs from each expert's angle
4. Let the human (guided by the Identity) make the call
5. Document the decision with the reasoning

#### Step 1 — Understand what you're building
Read VISION.md. Summarize: "Based on the vision, here's what the system needs to do..."
Highlight architecture principles from VISION.md that constrain choices.

#### Step 2 — Ecosystem and system overview
Ask:
- "What are the main pieces of the system?"
- "Are there external services this depends on? Other repos?"
- "How does a request flow from the user to the response?"

Consult Architect expert: "Given this overview, what are the boundaries?"
Consult Security expert: "What's the attack surface? Where are the trust boundaries?"

#### Step 3 — Tech stack (expert-guided)
For each layer (language, framework, database, hosting):
- Present 2-3 options with tradeoffs
- Architect: "Which gives the most flexibility to change later?"
- Infrastructure: "Which is simplest to deploy and operate?"
- Security: "Which has the better security story?"
- Human makes the final call
- Document the choice AND what was rejected and why

"Because I know it" is a valid reason — document it honestly.

#### Step 4 — Architecture style (the big decision)
Options: DDD, Clean/Hexagonal, MVC, Modular/flat, Mix
Architect recommends based on domain complexity and team size.
Once decided, DELETE sections from the template that don't apply.

#### Step 5 — Directory structure
Based on all decisions, propose the layout. Architect explains WHY.

#### Step 6 — Key design decisions
Document every non-obvious choice: what, why, what was the alternative.

#### Step 7 — Security review
Before finalizing: Security expert reviews auth flow, trust boundaries,
external integrations.

Use the template at `skills/architecture/template.md` as structure.
The test: can someone read this and understand the ENTIRE system?

### If ARCHITECTURE.md already exists — Update

1. Find the file: `fd ARCHITECTURE.md --exclude .git` (or `find . -name "ARCHITECTURE.md" -not -path "*/.git/*"`)
2. Read the current content
3. Read the template at `skills/architecture/template.md` for new sections
4. Identify: missing sections, stale decisions, or areas to improve
5. Merge approved additions, preserving all existing decisions and content

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "We'll figure out the architecture as we build" | You will — and each dev will figure out a different one. Without a written design, the codebase becomes three codebases in a trench coat. |
| "DDD / Clean Architecture is overkill for us" | Maybe. But "flat modular" is also an architectural choice — write it down. The problem isn't simplicity, it's silence. |
| "We don't need to document rejected alternatives" | In six months someone will propose the rejected option again. Without the record, you debate it from scratch. |
| "'Because I know it' isn't a real reason" | It absolutely is — familiarity lowers cost and accelerates delivery. Just write it down honestly instead of inventing post-hoc justifications. |
| "The diagram is enough" | A diagram shows shapes. Architecture is the reasoning behind the shapes. Without the why, diagrams lie as easily as they inform. |
| "We'll add the Security section later" | The attack surface is largest at the start, when assumptions are cheap. Security review after the stack is frozen is review theater. |

## Red Flags

- Tech stack listed without alternatives or reasoning ("Postgres" with no "why not X")
- Architecture style declared but directory structure contradicts it (DDD declared, flat `src/` layout)
- No Key Design Decisions section, or every entry has "TBD" in the reasoning column
- Security section is one paragraph of platitudes, no concrete trust boundaries
- Diagram present but no prose explaining the flow — pictures without captions
- Directory structure has generic folders (`utils/`, `helpers/`, `lib/`) without domain qualifiers
- No mention of how external services are integrated — every API call invented on the fly
- Decision log empty despite the project having a clear history of debates

## Verification

- [ ] `docs/ARCHITECTURE.md` exists at the project root
- [ ] System overview includes a request flow (either diagram or prose)
- [ ] Each tech stack choice documents at least one rejected alternative with reasoning
- [ ] Architecture style is explicit (DDD / Clean / MVC / Modular / Mix) — not implied
- [ ] Directory structure diagram matches the declared architecture style
- [ ] Key Design Decisions section has at least 3 entries with what/why/alternative
- [ ] Security section names trust boundaries and auth flow, not just "we use JWT"
- [ ] Unused template sections removed (no "DDD" section in a modular-flat project)
- [ ] `CLAUDE.md` → `Stack` field updated if the stack was decided here
- [ ] `.launchpad/manifest.yml` updated with `architecture: "1.1"` under `modules:`

## When done

If stack was decided, update `CLAUDE.md` → `Stack` field.
Update `.launchpad/manifest.yml` — set `architecture: "1.1"` under `modules:`.

Next likely skills:
- `workflow` — inform test strategy (unit/integration/e2e) from the architecture layers
- `agents` — AGENTS.md should reference architecture boundaries for "don't touch X without approval" rules
- `roadmap` — re-sequence phases if the architecture reveals new dependencies
