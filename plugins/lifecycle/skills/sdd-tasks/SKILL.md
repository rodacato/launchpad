---
name: sdd-tasks
description: SDD-lite step 3 — writes docs/sdd/<change-name>/tasks.md, an ordered checklist of atomic implementation steps derived from the accepted plan. Each task is small, sequenced, and verifiable. Use after sdd-plan is accepted and before any code changes start. Use when a change has more than ~3 implementation steps. NOT for one-line fixes or changes where the steps are already obvious from the plan.
metadata:
  version: "0.1"
---

# SDD Tasks

## Overview

Step 3 of SDD-lite. Writes `docs/sdd/<change-name>/tasks.md` — the ordered
checklist of atomic implementation steps that realize the accepted plan.
Each task is small enough to do in one focused session, sequenced so each
step's output is the next step's input, and verifiable on its own.

The tasks file is the contract `sdd-apply` executes against. A vague task
list produces a vague implementation; a tight one produces a clean diff.

## When to Use

- `sdd-plan` is accepted and the next step is implementation
- The change has more than ~3 implementation steps and order matters
- Multiple sessions / contributors will share the work and need a stable to-do contract
- The plan is correct but the path from "plan accepted" to "PR opened" needs structure

**When NOT to use:**
- Plan is still `draft` or has unresolved open questions — fix those first
- The plan IS the task list (the steps are already enumerated and atomic) — skip; go straight to apply
- One-line / trivial change — no task structure needed
- The change is exploratory and order will shift as you learn — that's not SDD, that's spike work

## Before you start

Required: `docs/sdd/<change-name>/plan.md` with status `accepted`. Read it
end-to-end before generating tasks. The "Module / file changes" and "Key
decisions" sections of the plan are the raw material for the task list.

```bash
cat docs/sdd/<change-name>/plan.md   # confirm status: accepted
cat docs/sdd/<change-name>/spec.md   # success criteria — tasks must serve them
```

## Process

### Step 1 — Extract the atomic units from the plan

Walk the plan's "Module / file changes" and "Key decisions" sections. For
each, ask:

- Can this be done in one focused session (~30-90 min)?
- Does it produce something verifiable on its own (a passing test, a
  successful build, a working endpoint)?
- Does it depend on a previous task's output?

If a change is larger than one focused session → split it. If it doesn't
produce something verifiable → either make it produce something or merge
it with the next task.

### Step 2 — Sequence the tasks

Order tasks so each one's output is usable input for the next. Common
sequencing patterns:

- **Schema → backend → frontend → tests** (data-flow direction)
- **Tests-first → implementation → integration** (TDD direction)
- **Scaffold → wire → polish** (breadth-first)
- **Migration → cleanup of old code** (only after the new path proves out)

If two tasks are independent, order doesn't matter — note that explicitly
in the file ("tasks 3 and 4 can swap").

### Step 3 — Identify checkpoints

Insert checkpoints — points where the work pauses for human review or for
a long-running step (CI run, manual QA, peer feedback). Format:

```
- [ ] CHECKPOINT — <what to verify, with whom>
```

Checkpoints prevent "I'll fix it at the end" from becoming "I built the
wrong thing for three days."

### Step 4 — Draft the file

Create `docs/sdd/<change-name>/tasks.md`:

```markdown
# Tasks — <change-name>

> Step 3 of SDD-lite. Status: pending | in-progress | done | abandoned
> Plan: [plan.md](./plan.md) (status: accepted)
> Spec: [spec.md](./spec.md) (status: accepted)

## Sequence

- [ ] 1. <atomic task — verb + concrete object>
      - Expected output: <what's true after this task>
      - Verify: <how to confirm — test name, command, observable>
      - Files touched: <list>
      - Depends on: <prior task # or "none">

- [ ] 2. <next task>
      ...

- [ ] CHECKPOINT — <what / with whom>

- [ ] 3. ...

## Out of sequence (any order)

- [ ] X. <task that doesn't depend on a specific predecessor>

## Notes

(populated by sdd-apply during execution — discoveries, deviations,
follow-ups)
```

Each task has all four sub-bullets. If you can't fill them, the task is
either too big (split) or too vague (refine).

### Step 5 — Show the draft + iterate

Share with the human. The most common rework: tasks that are actually
multiple tasks fused, or tasks that are too small to be worth tracking
separately. Iterate until the list reads as the right granularity.

Lock status to `pending` once the human accepts (it stays pending until
sdd-apply starts; then `in-progress`; then `done` when all tasks
checked).

### Step 6 — Write the file

Create `docs/sdd/<change-name>/tasks.md`. Commit:
`docs(sdd): add tasks for <change-name>`.

### Step 7 — Hand off

```
Tasks written: docs/sdd/<change-name>/tasks.md (status: pending)
Task count: <N> (plus <C> checkpoints)
Next step: /lifecycle:sdd-apply <change-name>
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll skip the verification line — it's obvious for each task" | "Obvious" verifications get skipped during apply. Writing the verification step makes "done" reproducible; without it, "done" is whatever the implementer thought at the time. |
| "Sequencing doesn't matter — I'll do them in any order" | Some tasks genuinely don't depend on order (note that explicitly). Most do — and discovering the dependency mid-implementation costs a redo. Sequence first; rearrange when an "out of sequence" task is genuinely free-standing. |
| "Smaller tasks feel like overhead" | Big tasks fail silently — you only know they're stuck after hours of work. Small tasks fail loudly, immediately, and recoverably. The overhead is the feedback signal. |
| "I'll add tasks as I go in apply" | Adding tasks during apply is fine. Skipping the planning step entirely produces a task list that grows by accident, with no shape. The initial list is the contract; growth happens against it, not instead of it. |
| "Checkpoints slow things down" | Checkpoints are cheap; the alternative — building three days the wrong direction — is expensive. Insert one before any irreversible step (database migration, deploy, breaking change). |
| "I'll combine plan and tasks for speed" | Plan answers "what's the right approach?". Tasks answers "in what order do I touch which file?". Combining produces a tasks list that's also a half-baked plan. The two artifacts serve different purposes. |

## Red Flags

- Tasks lack one or more of: Expected output / Verify / Files touched / Depends on
- A task is so big it spans multiple files AND multiple concepts (split it)
- Sequence has implicit dependencies not noted ("of course step 4 needs step 2's output")
- No checkpoints in a list with >8 tasks or before an irreversible step
- Tasks contradict the plan (touch a file the plan didn't list, skip a file the plan listed)
- Status is `pending` but the task list has placeholder TODOs
- "Out of sequence" section contains tasks that actually have ordering dependencies

## Verification

- [ ] `docs/sdd/<change-name>/tasks.md` exists
- [ ] Plan status is `accepted` (verified by re-reading the plan)
- [ ] Each task has Expected output / Verify / Files touched / Depends on
- [ ] No task is so big it would take a full day or span > 5 files
- [ ] Sequence is explicit; "out of sequence" tasks are genuinely independent
- [ ] At least one checkpoint exists before any irreversible step (DB migration, deploy, breaking change)
- [ ] Tasks cover every file change listed in the plan's "Module / file changes" section
- [ ] No task introduces a file change the plan didn't anticipate (if it did, plan needs an amendment first)
- [ ] Status reflects reality (`pending` until sdd-apply starts)
- [ ] Commit landed with `docs(sdd): add tasks for <change-name>`

## When done

Nothing to update in `.launchpad/manifest.yml` — sdd-tasks is a lifecycle
skill and produces a workflow artifact (tasks.md), not a project artifact.

Next likely skills:
- `lifecycle:sdd-apply` — execute the tasks one at a time, checking each off
- `lifecycle:sdd-verify` — only after sdd-apply marks all tasks done
