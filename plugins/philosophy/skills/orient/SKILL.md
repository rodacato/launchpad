---
name: orient
description: Meta-skill — load FIRST when uncertain which kwik-e-marketplace skill applies to the task at hand. Routes the task across launchpad / lifecycle / philosophy and returns the right skill name with one-line reasoning. Use when starting a session and the task isn't obvious. Use when a request could plausibly fit multiple skills. Use when the agent is about to "wing it" because nothing matched on first pass. Use to ground the agent in the inherited core principles and operating behaviors before any other skill loads.
metadata:
  version: "0.2"
---

# Orient

## Overview

`orient` is the meta-skill of kwik-e-marketplace. It does not produce an
artifact and does not perform an action. It does ONE thing: given the task
the human just described, point at the right skill (or say "no skill fits —
just do it") and load the inherited floor (`core-principles.md` +
`operating-behaviors.md`) so the agent operates from a known baseline.

This is the answer to "which skill should I use?" — and it is the answer to
"what does this marketplace even contain?" for a fresh session.

## When to Use

- Starting a session in a project that uses kwik-e-marketplace and you don't yet know which skill matches the task
- A request could plausibly fit two skills (e.g. "write the release notes" — `lifecycle:ship` or `launchpad:releasing`?) and you need a routing decision
- The agent skipped skill discovery on a previous turn and is about to "wing it" — pause, run `orient`, then continue with grounding
- Onboarding the human to what's installed — "what can you do for me on this project?" is answered by reading this skill's decision tree
- Before any non-trivial work, to load the inherited Core Principles and Operating Behaviors so they apply to whatever skill runs next

**When NOT to use:**
- The matching skill is obvious from the request ("review PR 42" → `lifecycle:review`, no orient needed)
- A skill is already loaded and actively executing — don't interrupt mid-flow
- Single-shot mechanical tasks (rename a variable, format a file) — those don't need a skill at all
- The task is outside the marketplace's scope entirely (no skill applies and no skill should)

## Before you start

Always read these two first. They are the floor for every skill that runs
after `orient`:

- `plugins/philosophy/shared/core-principles.md` — universal rules
  (verification before assertion, stop-and-wait, evidence over authority,
  scope discipline, …)
- `plugins/philosophy/shared/operating-behaviors.md` — situation-triggered
  reflexes (surface assumptions, manage confusion, push back, enforce
  simplicity, verify before "done")

```bash
fd -t f core-principles.md plugins/philosophy/shared
fd -t f operating-behaviors.md plugins/philosophy/shared
```

If either file is missing, the marketplace install is incomplete — surface
this to the human before proceeding.

## Process

### Step 1 — Load the floor

Read `core-principles.md` and `operating-behaviors.md` end-to-end. These
apply for the rest of the session regardless of which skill runs next. Do
not paraphrase them to the human unless asked — they're context for the
agent, not output for the human.

### Step 2 — Classify the task

Walk the decision tree below. The classification is by **what the task
leaves behind**, not by topic.

```text
Task arrives — what does completing it produce?

   File(s) in the target project's git tree?
       ├─ YES ──→ go to BOOTSTRAP routing (launchpad)
       └─ NO  ─→  Action affecting external state (PR comment, release tag, deployed change)?
                      ├─ YES ──→ go to LIFECYCLE routing
                      └─ NO  ─→  Reference / advisory / persona configuration?
                                     ├─ YES ──→ go to PHILOSOPHY routing
                                     └─ NO  ─→  no skill fits — execute directly,
                                                guided by core-principles + operating-behaviors
```

### Step 3 — Route within the chosen plugin

#### BOOTSTRAP — `launchpad` (produces a file in the target project)

| The human wants… | Use |
|---|---|
| Project compass / problem statement / philosophy | `launchpad:vision` |
| System design, stack, domain model | `launchpad:architecture` |
| Brand identity, voice, palette, microcopy | `launchpad:branding` |
| Phased plan, what's-built / what's-next / what's-NOT | `launchpad:roadmap` |
| Team workflow (Issue → Branch → PR → Merge), playbooks | `launchpad:workflow` |
| AGENTS.md — agent roles, startup contract | `launchpad:agents` |
| Showroom metadata for rodacato.github.io/projects | `launchpad:notdefined` |
| GitHub repo setup — labels, templates, branch protection | `launchpad:github` |
| Devcontainer for reproducible dev env | `launchpad:devcontainer` |
| Kamal deployment to own servers | `launchpad:kamal` |
| Caddyfile reverse proxy + HTTPS | `launchpad:caddy` |
| Release process **doc** (not the action) | `launchpad:releasing` |
| CONTRIBUTING.md | `launchpad:contributing` |
| CHANGELOG.md scaffolding (Keep a Changelog) | `launchpad:changelog` |

#### LIFECYCLE — `lifecycle` (performs an action)

| The human wants… | Use |
|---|---|
| Multi-axis review of an open PR | `lifecycle:review` |
| Branch from issue / commit / open PR (project-aware git hygiene) | `lifecycle:git-workflow` |
| Systematically debug a failing test, build, or behavior | `lifecycle:debugging` |
| Audit a diff and propose deletions for code that doesn't earn its keep | `lifecycle:simplify` |
| Cut a release (bump, CHANGELOG, tag, push, GitHub release) | `lifecycle:ship` |

> **SDD-lite skills** (`sdd-spec`, `sdd-plan`, `sdd-tasks`, `sdd-apply`,
> `sdd-verify`) are tracked in the marketplace plan but not yet shipped.
> If the request fits one of those — name it, suggest the human file an
> issue, and execute directly using `core-principles` + `operating-behaviors`
> as guidance.

#### PHILOSOPHY — `philosophy` (reference / advisory / persona)

| The human wants… | Use |
|---|---|
| Consult the expert advisory panel on a decision | `philosophy:panel` |
| Build / refresh `docs/IDENTITY.md` (project persona) | `philosophy:identity` |
| Build / refresh user-level Claude Code output style (voice, idioms) | `philosophy:voice` |
| Find the right skill (you are here) | `philosophy:orient` |

### Step 4 — Disambiguate when two skills could fit

Apply these tie-breakers, in order, until one wins:

1. **Producing a file vs. taking an action?** File → `launchpad`. Action →
   `lifecycle`. (Resolves `launchpad:releasing` vs. `lifecycle:ship` —
   one writes the doc, the other cuts the release.)
2. **Project-scoped vs. user-global?** Project → `launchpad` /
   `lifecycle`. User-global → `philosophy:voice`. (Resolves "set up the
   agent's voice" → `voice`, not `agents`.)
3. **What the agent THINKS vs. how the agent SOUNDS?** Thinks →
   `philosophy:identity`. Sounds → `philosophy:voice`. Both can exist on the
   same project with different scopes.
4. **Refresh-the-floor vs. project work?** If the task is "update the
   universal rules" — that's the shared source files (`core-principles.md`,
   `operating-behaviors.md`), not a skill.
5. **Investigation vs. execution?** Investigation (why is X broken? what's
   the diff doing wrong?) → `lifecycle:debugging` or `lifecycle:simplify`.
   Execution (commit, PR, release) → `lifecycle:git-workflow` or
   `lifecycle:ship`.
6. **Diff-as-evidence vs. diff-as-target?** Reviewing a PR for
   correctness / architecture / security → `lifecycle:review`. Auditing
   YOUR OWN recent diff to remove what doesn't earn its keep before opening
   the PR → `lifecycle:simplify`. Different audiences, different bars.
7. **Fix vs. investigate?** If the cause is unknown →
   `lifecycle:debugging` first (find the cause, write the regression test).
   If the cause is known and the change is mechanical → no skill, just do
   it (with `core-principles` loaded).

### Step 5 — Report the routing

Tell the human in one short message:

```
Based on the task, I'd run: <skill-name>
Reasoning: <one line — what the task produces / what it acts on>
Loading: <skill SKILL.md path> + the inherited floor (core-principles, operating-behaviors)
```

Then either run the skill directly OR wait for the human's nod, depending
on the task's reversibility.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The task is simple, I don't need to orient" | Maybe. But running `orient` once at session start loads the floor for free. The cost is ~2 minutes of reading; the benefit is consistent behavior across the session. |
| "I'll skip core-principles / operating-behaviors loading — I know them" | The agent's "memory" of these resets every session. Loading them inline is the only way they actually apply. Skipping is the pattern that produces the agent that "feels different today." |
| "Two skills could fit, I'll just pick one" | Pick AFTER applying Step 4 tie-breakers. Picking before is a coin flip that erodes routing consistency over time. |
| "Lifecycle has nothing for this — I'll skip orient" | The decision tree's last branch IS "no skill fits — execute directly." That's a valid output of `orient`, not a reason to skip it. The floor still loads. |
| "If orient is auto-loaded I don't need a command" | The command exists for the case where the agent already started without it. The human triggers it explicitly to course-correct mid-session. |

## Red Flags

- Agent runs a skill without first reading `core-principles.md` and `operating-behaviors.md`
- Routing tables in this skill drift out of sync with the actual installed plugins (e.g. a new `lifecycle:debug` ships but isn't listed here)
- Tie-breakers (Step 4) aren't applied — agent picks the first plausible skill instead of disambiguating
- `orient` runs but the agent doesn't report back the chosen skill in the format from Step 5
- Two skills compete for the same task in the routing table without a tie-breaker covering them
- Agent invokes `orient` on a request where the matching skill is unambiguous (review PR → `lifecycle:review`); wastes the human's time

## Verification

- [ ] `plugins/philosophy/shared/core-principles.md` was read this session
- [ ] `plugins/philosophy/shared/operating-behaviors.md` was read this session
- [ ] The classification decision (BOOTSTRAP / LIFECYCLE / PHILOSOPHY / NONE) is stated explicitly
- [ ] If a skill was selected: the routing table row that produced it is referenced
- [ ] If two skills could fit: the Step 4 tie-breaker that resolved it is named
- [ ] Step 5 message format is followed verbatim (skill name + reasoning + loading line)
- [ ] When NO skill fits: the agent says so and proceeds with floor-only guidance, instead of forcing a misfit skill

## When done

Nothing to update in `.launchpad/manifest.yml` — `orient` is a philosophy
meta-skill and produces a routing decision, not a project artifact.

Next likely skills: whatever Step 5 chose. If `orient` returned "no skill
fits", proceed directly with the work — the floor is loaded and that's what
matters.
