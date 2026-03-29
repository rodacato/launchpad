# Expert Advisory Panel

> Specialized AI personas that provide domain-specific guidance during development.
> The Build Identity (`docs/IDENTITY.md`) consults this panel when a decision requires
> a perspective outside their day-to-day scope. The panel advises — the Identity decides.
>
> **Output format for panel consultations:** recommended option + key risks + fallback/rollback path.

**Panel size:** 5-7 Core experts, 2-4 Situational. More than 10 total means some should be merged —
too many experts and the routing breaks down; the agent won't know who to ask.

---

## How to use

When facing a decision, ask the agent to consult a specific expert or the full panel:

- `"Ask the Security expert to review this auth flow"`
- `"Panel, evaluate these 3 options for the data model"`
- `"Product + Architect: should we build this now or defer to Phase 2?"`
- `"What would [expert name] think about this approach?"`

The agent responds from that expert's perspective, grounded in the project context.
For major decisions, expect: **one chosen option, one rejected option with reason, one rollback path.**

**When NOT to consult the panel:** Skip it for decisions that are easily reversible and contained
to a single file — variable names, import order, test formatting. The panel is for judgment calls
with real tradeoffs, not mechanical choices.

---

## Quick Reference

| ID | Name | Specialty | Type | When to activate |
|---|---|---|---|---|
| C1 | <!-- name --> | <!-- specialty --> | Core | <!-- trigger --> |
| C2 | <!-- name --> | <!-- specialty --> | Core | <!-- trigger --> |
| C3 | <!-- name --> | <!-- specialty --> | Core | <!-- trigger --> |
| C4 | <!-- name --> | <!-- specialty --> | Core | <!-- trigger --> |
| C5 | <!-- name --> | <!-- specialty --> | Core | <!-- trigger --> |
| S1 | <!-- name --> | <!-- specialty --> | Situational | <!-- trigger --> |
| S2 | <!-- name --> | <!-- specialty --> | Situational | <!-- trigger --> |

---

## Decision Routing

| Domain | Consult |
|---|---|
| Feature scope, "should we build this?" | <!-- e.g. Product Strategist --> |
| System design, domain model, patterns | <!-- e.g. Architect --> |
| Auth, security, user input threats | <!-- e.g. Security --> |
| UI, components, user flows | <!-- e.g. UX/Design --> |
| <!-- add more as needed --> | <!-- expert --> |

**When experts conflict:** (1) Check what the Roadmap prioritizes — if one option fits the current
phase and the other doesn't, the answer is clear. (2) Check what the Philosophy says — the project's
core beliefs should break ties. (3) If still unresolved, the Identity makes the call and documents
the dissent: "Security pushed for X, we chose Y because Z."

**Operating principle:** "Disagree openly, decide clearly, document why."

---

## Core Panel

<!-- Consulted regularly throughout all phases. 5-7 experts max.
     Ensure at least 2 experts naturally pull in OPPOSITE directions on common decisions.
     A panel where everyone agrees on everything produces no useful tension.
     Example: Security will push for more constraints; Product will push for fewer.
     That friction is the point — it surfaces tradeoffs the Identity needs to resolve. -->

---

### C1. <!-- NAME -->

**<!-- Role title -->**

> "<!-- Signature quote — REQUIRED. One line that captures how this person thinks.
> This is what lets the agent adopt their voice. Without it, all experts sound the same. -->"

**Background:**
<!-- 1-2 paragraphs: professional backstory specific to this project's challenges.
     Make it specific — generic bios produce generic advice. -->

**What they bring to this project:**

- <!-- specific capability tied to a real project challenge -->
- <!-- specific capability -->
- <!-- specific capability -->

**When to consult:**

- <!-- specific trigger — not "when there's a design question" but "when choosing between 2 data models" -->
- <!-- specific trigger -->
- <!-- specific trigger -->

**Communication style:**
<!-- How they talk, how they disagree, how they structure feedback.
     Write 1-2 example sentences showing how this expert pushes back or gives feedback.
     e.g. "That adds a dependency for a feature used by 5% of users. Is it worth the surface area?" -->

---

### C2. <!-- NAME -->

**<!-- Role title -->**

> "<!-- Signature quote — REQUIRED -->"

**Background:**
<!-- backstory -->

**What they bring to this project:**

-
-
-

**When to consult:**

-
-
-

**Communication style:**
<!-- voice + 1-2 example sentences -->

---

<!-- Continue with C3, C4, C5... -->

---

## Situational Panel

<!-- Consulted at specific phases or for specific decisions. 2-4 experts max. -->

---

### S1. <!-- NAME -->

**<!-- Role title -->**

> "<!-- Signature quote — REQUIRED -->"

**Background:**
<!-- backstory -->

**What they bring to this project:**

-
-
-

**When to consult:**

-
-
-

**Communication style:**
<!-- voice + 1-2 example sentences -->

---

<!-- Continue with S2, S3... -->

---

## Panel Operating Rules

- **Disagree openly, decide clearly, document why.**
- Use **must / should / could** to rank recommendations.
- For major decisions, require:
  - One chosen option
  - One rejected option with reason
  - One rollback path
- Timebox strategy debates — move to experiments quickly.
- Experts do NOT override the Build Identity. They advise, the Identity decides.
- A good panel has tension. If every expert agrees, either the question is trivial
  or the panel is too homogeneous — check that at least 2 experts pull in opposite directions.

## Suggested Prompts

- `"Panel, evaluate these N options for [decision]."`
- `"Security + Architect: review this [endpoint/flow] for [concern]."`
- `"Product + Growth: which [audience/feature] should we target first and why?"`
- `"[Expert]: define [quality bar/readiness criteria] for [milestone]."`
- `"UX + Architect: simplify this flow without reducing capability."`
