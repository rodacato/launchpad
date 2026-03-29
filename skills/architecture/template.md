# Architecture

> Everything you need to understand the system before writing a line of code.
> The agent reads this to make informed technical decisions.

---

## Ecosystem

```
<!-- project.example.com   — this repo — description
     other-service.example  — separate repo — description
     external-api.com        — third-party dependency -->
```

---

## System Overview

```
<!-- [Browser]
    ↓ HTTPS
[Frontend — React + Vite]
    ↓ REST / WebSocket
[API — Hono + Node.js]
    ↓              ↓
[PostgreSQL]  [External API] -->
```

---

## Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| Language | <!-- e.g. TypeScript --> | <!-- e.g. Type safety, team familiarity --> |
| Framework | <!-- e.g. Hono --> | <!-- e.g. Lightweight --> |
| Database | <!-- e.g. PostgreSQL 16 --> | <!-- e.g. Proven, extensible --> |
| Cache | <!-- e.g. Redis / none --> | <!-- or "not needed yet" --> |
| Hosting | <!-- e.g. Fly.io --> | <!-- e.g. Simple deploys --> |
| Frontend | <!-- e.g. React + Vite --> | <!-- e.g. Fast builds --> |
| Auth | <!-- e.g. GitHub OAuth --> | <!-- e.g. Target audience uses GitHub --> |

---

## Architecture Style

<!-- What pattern(s) does this project follow? Why?
     DELETE the sections below that don't apply. -->

---

## Directory Structure

```
<!-- src/
├── domain/          # Aggregates, entities, value objects
├── application/     # Use cases
├── infrastructure/  # Routes, repos, external clients
└── shared/          # Types, schemas, utilities -->
```

---

## Bounded Contexts

<!-- DELETE if not using DDD. -->

```
<!-- ┌─────────────────────────┐
│  Core Domain           │
│  publishes: EventA     │
└──────────┬─────────────┘
           │
    ┌──────┴──────┐
    ▼             ▼
┌──────────┐  ┌──────────┐
│ Context A│  │ Context B│
└──────────┘  └──────────┘ -->
```

---

## Domain Model

<!-- DELETE if not using DDD. -->

### <!-- Context Name -->

**<!-- Aggregate Root Name -->**

```typescript
// class Example {
//   id: ExampleId
//   status: "active" | "completed"
// }
```

---

## Domain Events

<!-- DELETE if not using DDD/event-driven. -->

| Event | Published by | Consumed by | Payload |
|---|---|---|---|

---

## Ports & Adapters

<!-- DELETE if not using hexagonal/clean architecture. -->

### Ports (interfaces)

```typescript
// interface ExamplePort {
//   save(entity: Entity): Promise<void>
//   findById(id: string): Promise<Entity | null>
// }
```

### Adapters (implementations)

| Port | Adapter | Notes |
|---|---|---|

---

## Application Layer (Use Cases)

<!-- DELETE if not using clean architecture. -->

```typescript
// CreateExample(data) → Example
//   → calls RepositoryPort.save()
//   → publishes ExampleCreated
```

---

## External Dependencies

| Dependency | Purpose | Criticality | Failure mode |
|-----------|---------|-------------|-------------|
| <!-- e.g. GitHub API --> | <!-- e.g. OAuth --> | <!-- high --> | <!-- e.g. Users can't log in --> |

---

## Auth

<!-- How authentication and authorization work. -->

---

## Key Design Decisions

**<!-- Decision title -->**
<!-- What was decided and why. What was the alternative? -->

<!-- For big decisions, link to docs/adr/NNN-title.md -->

---

## Integration Points

<!-- DELETE if not applicable. -->

### <!-- Integration name -->

<!-- Connection details, streaming behavior, error handling, env vars. -->
