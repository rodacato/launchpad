# Module: architecture

## What this installs

`docs/ARCHITECTURE.md` — System design, tech stack, domain model, key decisions.
This is the blueprint someone reads to understand the ENTIRE system without
looking at a single line of code.

## Before you start

Search for these files by name (they inform architecture decisions):
- `VISION.md` — architecture principles and litmus test live here
- `IDENTITY.md` — the Build Identity's stack expertise and decision style
- `EXPERTS.md` — consult the Architect, Security, and Infrastructure experts here

Use: `find . -name "VISION.md" -not -path "*/.git/*"`

---

## If ARCHITECTURE.md does NOT exist — Create

The architecture is built through guided decisions. For each major choice:
1. Present the decision and the options
2. Consult the relevant experts (adopt their voice, give their perspective)
3. Show tradeoffs from each expert's angle
4. Let the human (guided by the Identity) make the call
5. Document the decision with the reasoning

### Step 1 — Understand what you're building
Read VISION.md. Summarize: "Based on the vision, here's what the system needs to do..."
Highlight architecture principles from VISION.md that constrain choices.

### Step 2 — Ecosystem and system overview
Ask:
- "What are the main pieces of the system?"
- "Are there external services this depends on? Other repos?"
- "How does a request flow from the user to the response?"

Consult Architect expert: "Given this overview, what are the boundaries?"
Consult Security expert: "What's the attack surface? Where are the trust boundaries?"

### Step 3 — Tech stack (expert-guided)
For each layer (language, framework, database, hosting):
- Present 2-3 options with tradeoffs
- Architect: "Which gives the most flexibility to change later?"
- Infrastructure: "Which is simplest to deploy and operate?"
- Security: "Which has the better security story?"
- Human makes the final call
- Document the choice AND what was rejected and why

"Because I know it" is a valid reason — document it honestly.

### Step 4 — Architecture style (the big decision)
Options: DDD, Clean/Hexagonal, MVC, Modular/flat, Mix
Architect recommends based on domain complexity and team size.
Once decided, DELETE sections from the template that don't apply.

### Step 5 — Directory structure
Based on all decisions, propose the layout. Architect explains WHY.

### Step 6 — Key design decisions
Document every non-obvious choice: what, why, what was the alternative.

### Step 7 — Security review
Before finalizing: Security expert reviews auth flow, trust boundaries,
external integrations.

Use the template at `modules/architecture/template.md` as structure.
The test: can someone read this and understand the ENTIRE system?

---

## If ARCHITECTURE.md already exists — Update

1. Find the file: `find . -name "ARCHITECTURE.md" -not -path "*/.git/*"`
2. Read the current content
3. Check the template for new sections:
   `https://raw.githubusercontent.com/rodacato/launchpad/master/modules/architecture/template.md`
4. Identify: missing sections, stale decisions, or areas to improve
5. For each gap, ask the human if they want to fill it
6. Merge approved additions, preserving all existing decisions and content

---

## When done

If stack was decided, update `CLAUDE.md` → `Stack` field.

Update `.launchpad/manifest.yml`:
- Add `architecture: "1.0"` under `modules:`

Then delete `LAUNCHPAD_TASK.md`.
