# Architecture

> Everything you need to understand the system before writing a line of code.
> The agent reads this to make informed technical decisions. Keep it updated.
>
> This document should answer: "How does this system work and why was it built this way?"

---

<!-- AGENT INSTRUCTIONS — How to fill this document

This document is the RESULT of a guided architectural exploration.
It's not filled in isolation — the agent uses the Vision, Identity, and Expert Panel
to help the human make informed decisions. The experts debate, the Identity decides,
and this document captures those decisions.

PREREQUISITES (read ALL before starting):
  - docs/VISION.md — the philosophy, architecture principles, and litmus test
  - docs/IDENTITY.md — the Build Identity's stack expertise and decision style
  - docs/EXPERTS.md — the expert panel, especially the Architect, Security,
    and Infrastructure experts

THE PROCESS:

The architecture is built through a series of decisions. For each major decision,
the agent should:
  1. Present the decision and the options
  2. Consult the relevant experts from the panel (adopt their voice, give their perspective)
  3. Show tradeoffs from each expert's angle
  4. Let the human (guided by the Identity) make the call
  5. Document the decision with the reasoning

This is NOT "fill in the blanks." This is a conversation where the human
arrives at the right architecture for THEIR project, with expert guidance.

STEP 1 — Understand what we're building
  Read VISION.md. Summarize back to the human:
  - "Based on the vision, here's what I understand the system needs to do..."
  - "The architecture principles from the vision say [X]. That constrains our choices."
  - "Let me ask the relevant experts what they think."

STEP 2 — Ecosystem & System Overview
  Ask the human:
  - "What are the main pieces of the system? Draw me the big picture."
  - "Are there external services this depends on? Other repos?"
  - "How does a request flow from the user to the response?"

  Consult the Architect expert:
  - "Given this system overview, what are the boundaries? What talks to what?"
  Consult the Security expert:
  - "What's the attack surface? Where are the trust boundaries?"

  Create the system overview diagram (ASCII is fine).

STEP 3 — Tech Stack (Expert-Guided)
  For each layer (language, framework, database, hosting, etc.):
  - Present 2-3 options with tradeoffs
  - Have the relevant experts weigh in:
    - Architect: "Which option gives us the most flexibility to change later?"
    - Infrastructure: "Which is simplest to deploy and operate?"
    - Security: "Which has the better security story out of the box?"
  - The human makes the final call
  - Document the choice AND what was rejected and why

  "Because I know it" is a valid reason — document it honestly.
  The experts might push back, but familiarity is a real engineering advantage.

STEP 4 — Architecture Style (The Big Decision)
  This is the most important decision. Present the options:
  - DDD with bounded contexts — when the domain is complex enough to justify it
  - Clean/Hexagonal Architecture — when you need clear port/adapter boundaries
  - Simple MVC — when the domain is straightforward
  - Modular/flat — when simplicity is the priority
  - Mix and match — most projects blend patterns

  Have the Architect expert make a recommendation based on:
  - The project's complexity (is there a real domain to model?)
  - The team size (DDD overhead for a solo dev?)
  - The Vision's architecture principles

  Ask the human:
  - "The Architect recommends [X] because [Y]. Does that feel right?"
  - "Where does business logic live? Where does it NOT live?"

  Once decided, ADAPT the document structure:
  - If DDD: keep Bounded Contexts, Domain Model, Domain Events, Ports & Adapters
  - If Clean/Hexagonal: keep Layers, Ports & Adapters, Use Cases
  - If modular/flat: keep Directory Structure, Key Modules, Request Flow
  - If simple MVC: keep Models, Controllers, Services
  - DELETE sections that don't apply

STEP 5 — Domain Model (if DDD/Clean Architecture)
  This is where the Architect expert leads. Ask:
  - "What are the core concepts? What's the aggregate root?"
  - "What events happen in the system?"
  - "What are the boundaries between different areas of the domain?"

  Have the Architect define:
  - Bounded contexts with their relationships
  - Aggregates, entities, value objects
  - Domain events (the ONLY coupling between contexts)
  - Ports (interfaces) and adapters (implementations)

  Use TypeScript interfaces, pseudocode, or whatever fits the stack.

STEP 6 — Directory Structure
  Based on all decisions above, propose the directory layout.
  Have the Architect explain WHY this structure and not another.
  Ask: "Does this match how you think about the code?"

STEP 7 — Key Design Decisions
  Go through every non-obvious choice made during the process.
  For each:
  - What was decided
  - Why (which expert recommended it, what the tradeoff was)
  - What was the alternative and why it lost

  Small decisions: one line. Big ones: link to a formal ADR.

STEP 8 — Security & Integration Review
  Before finalizing, have the Security expert review:
  - Auth flow: "How do users authenticate? What tokens? What's shared?"
  - Trust boundaries: "Where does user input enter the system?"
  - External integrations: "What happens when an external service is down?"

STEP 9 — Draft and iterate
  Show the full architecture doc to the human.
  The test: can someone read this and understand the ENTIRE system
  without looking at a single line of code?

-->

## Ecosystem

<!-- What services/repos make up the full system?
     Include this project AND anything it talks to. -->

```
<!-- e.g.
project.notdefined.dev      # this repo — the main application
other-service.notdefined.dev # separate repo — description
external-api.com             # third-party dependency
-->
```

<!-- One sentence: how do these services relate to each other? -->

---

## System Overview

<!-- The big picture. How does a request flow through the system?
     ASCII diagram showing main components and their connections.
     Include: user, frontend, backend, database, external services. -->

```
<!-- e.g.
[Browser]
    ↓ HTTPS
[Frontend — React + Vite]
    ↓ REST / WebSocket
[API — Hono + Node.js]
    ↓              ↓
[PostgreSQL]  [External API]
-->
```

<!-- 1-2 paragraphs explaining the flow, protocols, and why. -->

---

## Tech Stack

<!-- Every choice needs a WHY. "Because I know it" counts — be honest. -->

| Layer | Technology | Why |
|-------|-----------|-----|
| Language | <!-- e.g. TypeScript --> | <!-- e.g. Type safety, team familiarity --> |
| Framework | <!-- e.g. Hono --> | <!-- e.g. Lightweight, native WS support --> |
| Database | <!-- e.g. PostgreSQL 16 --> | <!-- e.g. Proven, extensible --> |
| Cache | <!-- e.g. Redis / none --> | <!-- e.g. Session store, or "not needed yet" --> |
| Hosting | <!-- e.g. Hetzner VPS + Kamal --> | <!-- e.g. Full control, low cost --> |
| Frontend | <!-- e.g. React + Vite --> | <!-- e.g. Fast builds, SPA --> |
| Auth | <!-- e.g. GitHub OAuth --> | <!-- e.g. Target audience uses GitHub --> |

---

## Architecture Style

<!-- What pattern(s) does this project follow? Why?
     e.g. "DDD with hexagonal architecture because the domain is complex enough
     to justify the boundary cost. Clean separation lets us swap the LLM provider
     without touching business logic." -->

<!-- DELETE the sections below that don't apply to your chosen style.
     Keep only what's relevant. A simple Express app doesn't need Bounded Contexts. -->

---

## Directory Structure

<!-- The physical layout of the code. Should mirror the architecture style. -->

```
<!-- e.g.
src/
├── domain/          # Aggregates, entities, value objects, port interfaces
├── application/     # Use cases — orchestrate domain + call ports
├── infrastructure/  # Adapters: routes, repos, external clients, event bus
└── shared/          # Types, schemas, utilities shared across layers
-->
```

---

## Bounded Contexts

<!-- DELETE this section if not using DDD.
     Define the domain boundaries. What areas of the system are independent?
     What events cross boundaries? -->

```
<!-- e.g.
┌─────────────────────────────────────────┐
│  Core Domain                            │
│  MainAggregate · Entity · ValueObject   │
│                                         │
│  publishes: DomainEvent1, DomainEvent2  │
└──────────────────┬──────────────────────┘
                   │ domain events
       ┌───────────┴────────────┐
       ▼                        ▼
┌─────────────┐        ┌───────────────┐
│ Supporting  │        │ Supporting    │
│ Context A   │        │ Context B     │
└─────────────┘        └───────────────┘

┌───────────────────┐
│ Generic Context   │
│ (e.g. Identity)   │
└───────────────────┘
-->
```

<!-- Explain each context:
     - What it owns
     - Whether it's Core, Supporting, or Generic
     - What events it publishes or consumes -->

---

## Domain Model

<!-- DELETE this section if not using DDD.
     Define aggregates, entities, and value objects.
     Use TypeScript interfaces, pseudocode, or whatever fits the stack. -->

### <!-- Context Name -->

**<!-- Aggregate Root Name -->**

<!-- What it represents, invariants it enforces, lifecycle. -->

```typescript
// Example:
class Session {
  id: SessionId
  userId: UserId
  status: "active" | "completed" | "failed"
  // ... fields

  // Invariants:
  // - cannot be modified after completion
  // - ...
}
```

**<!-- Entity / Value Object Name -->**

<!-- Continue for each important domain concept. -->

---

## Domain Events

<!-- DELETE this section if not using DDD/event-driven.
     Events published by aggregates. The only coupling between bounded contexts. -->

| Event | Published by | Consumed by | Payload |
|---|---|---|---|
| <!-- e.g. SessionCompleted --> | <!-- aggregate --> | <!-- context --> | <!-- key fields --> |

---

## Ports & Adapters

<!-- DELETE this section if not using hexagonal/clean architecture.
     Ports = interfaces defined by the domain.
     Adapters = infrastructure implementations. -->

### Ports (interfaces)

```typescript
// Example:
interface LLMPort {
  evaluate(prompt: string, context: string): AsyncIterator<Token>
}

interface RepositoryPort {
  save(entity: Entity): Promise<void>
  findById(id: string): Promise<Entity | null>
}
```

### Adapters (implementations)

| Port | Adapter | Notes |
|---|---|---|
| <!-- port --> | <!-- adapter --> | <!-- e.g. Primary, used in tests, etc. --> |

---

## Application Layer (Use Cases)

<!-- DELETE this section if not using clean architecture.
     Use cases orchestrate domain objects and call ports.
     They do NOT contain business logic — that lives in aggregates. -->

```typescript
// Example:
StartSession(userId, options) → Session
  // → calls RepositoryPort.findEligible()
  // → creates Session aggregate
  // → publishes SessionCreated
```

---

## Request Flow

<!-- DELETE this section if the system overview diagram is sufficient.
     For more complex systems, show the detailed request flow
     through middleware, handlers, routing, and providers. -->

```
<!-- e.g.
HTTP Request
  │
  ▼
┌─────────────────────────────────┐
│  Middleware Chain                 │
│  1. Parse body                   │
│  2. Auth (Bearer token)          │
│  3. Rate limiting                │
│  4. Request logging              │
└──────────┬──────────────────────┘
           │
           ▼
┌─────────────────────────────────┐
│  Handler                         │
│  • Validate input                │
│  • Call use case                 │
│  • Return response               │
└──────────┬──────────────────────┘
           │
           ▼
  Response
-->
```

---

## Key Modules

<!-- DELETE this section if directory structure is sufficient.
     For larger systems, explain what each major module does
     and how it relates to others. -->

### <!-- module name -->

<!-- What it does, key files, dependencies, gotchas. -->

---

## External Dependencies

<!-- APIs, services, or systems this project depends on. -->

| Dependency | Purpose | Criticality | Failure mode |
|-----------|---------|-------------|-------------|
| <!-- e.g. GitHub API --> | <!-- e.g. OAuth --> | <!-- high --> | <!-- e.g. Users can't log in --> |

---

## Auth

<!-- How authentication and authorization work.
     What's the flow? What tokens? What's shared across services? -->

---

## Key Design Decisions

<!-- For every non-obvious choice, document WHAT and WHY.
     Small decisions can be a single line. Big ones get full ADR treatment.
     These prevent future developers (or the agent) from re-debating settled questions. -->

**<!-- Decision title -->**
<!-- What was decided and why. What was the alternative? -->

**<!-- Decision title -->**
<!-- What was decided and why. -->

<!-- For decisions big enough for a formal ADR, link to docs/adr/NNN-title.md
     and track them in docs/ROADMAP.md history tables. -->

---

## Integration Points

<!-- DELETE if not applicable.
     How this project integrates with external services.
     Protocols, streaming contracts, error handling, retry strategies. -->

### <!-- Integration name (e.g. LLM, external API, sibling service) -->

<!-- Connection details, streaming behavior, error handling,
     configuration (env vars), and what happens when it's down. -->

---

## Exercise / Content Types

<!-- DELETE if not applicable.
     If the project has different modes, content types, or feature variants,
     document them here with how each one works architecturally. -->
