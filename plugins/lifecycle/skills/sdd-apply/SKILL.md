---
name: sdd-apply
description: SDD-lite step 4 — executes the next unchecked task from docs/sdd/<change-name>/tasks.md, verifies it, marks it done, and stops at every checkpoint. Loop one task at a time; do NOT batch. Use after sdd-tasks is accepted and you're ready to implement. Use to resume work mid-change. NOT for ad-hoc work outside the tasks file — that breaks the contract.
metadata:
  version: "0.1"
---

# SDD Apply

## Overview

Step 4 of SDD-lite. Reads `docs/sdd/<change-name>/tasks.md`, finds the
next unchecked task, executes it, runs the task's own verification, and
checks the box. Stops at every CHECKPOINT and waits for the human.

The skill is one-task-at-a-time on purpose. Batching tasks defeats the
checkpoint mechanism and turns SDD into "go implement the whole thing,"
which is exactly what SDD exists to prevent.

## When to Use

- `sdd-tasks` is accepted and you're ready to write code
- Resuming a change that was paused — the tasks.md checkboxes hold the cursor
- A new session starts mid-change and you need to find "where were we?"
- The human says "continue", "next task", "keep going"

**When NOT to use:**
- Tasks file is `pending` because tasks are still being refined — refine first
- The work needed isn't on the tasks list — STOP. Either amend the tasks file (if the work belongs in this change) or do the work outside SDD entirely (if it doesn't)
- The previous task's CHECKPOINT hasn't been resolved — wait for the human to pass it
- All tasks are checked and you'd be inventing new ones — go to sdd-verify instead

## Before you start

Required: `docs/sdd/<change-name>/tasks.md`. Read the whole file before
picking the next task — context from prior tasks shapes the next one.

```bash
cat docs/sdd/<change-name>/tasks.md
git status                          # working tree state
git branch --show-current           # are we on the change's branch?
```

If working tree is dirty with un-related changes: STOP and ask the human to
stash / commit them first. SDD apply runs against a clean slate so the diff
is attributable to one task.

## Process

### Step 1 — Locate the next task

Walk `tasks.md` top to bottom. Pick the first unchecked item.

If the next item is a CHECKPOINT:
- STOP.
- Tell the human: "Reached CHECKPOINT — <description>. Verify with
  <whom>. Reply 'pass' to continue, 'fail' to stop, or 'amend' to update
  the tasks file."
- Wait. Do not pick the task after the checkpoint until the human passes it.

If all tasks are checked: STOP. Tell the human:
"All tasks checked. Next step: /lifecycle:sdd-verify <change-name>."

### Step 2 — Confirm the task is still valid

Re-read the task's Expected output / Verify / Files touched / Depends on.
Sanity-check:

- Did a prior task's actual output match its expected output? If not, this
  task may need amendment before execution
- Does "Depends on" reference a task that's checked? If not, you're out of
  sequence — STOP and either reorder or fix the dependency note
- Is the file list still accurate? Recent commits may have moved files

If anything has drifted: pause and tell the human. Do not improvise.

### Step 3 — Execute the task

Do the work. Stay scoped to the task's Files touched list. If you find
yourself needing to touch a file outside that list:

- If the touch is genuinely required by this task: pause, amend the
  tasks file (Step 5), then continue
- If it's "while I'm here" cleanup: STOP. That's a separate task or a
  separate change. Don't smuggle it in

Keep the diff narrow. The tasks list IS the contract — apply executes it
faithfully or amends it openly.

### Step 4 — Run the task's verification

Run the Verify step from the tasks file. Capture the actual output.

If verification passes: proceed to Step 5.
If verification fails:
- DON'T mark the task done
- Diagnose: is the verification wrong (revise it) or is the work wrong
  (revise the work)?
- If you can't tell quickly, STOP and surface to the human

### Step 5 — Update the tasks file

Mark the task `[x]`. If you discovered something that future tasks need
to know about, append a short note under the file's "Notes" section:

```markdown
## Notes

- Task 3: actual output diverged from expected — <one line>; updated task 5 accordingly.
- Task 5: amended Files touched to include `lib/x.ts` (needed by task 3 finding).
```

Commit the implementation + the tasks-file update together (per
lifecycle:git-workflow). Commit message:
`<type>(<scope>): <task description> [SDD <change-name> task <N>]`

Example: `feat(auth): add JWT exp validation [SDD jwt-exp task 3]`

### Step 6 — Report and pause

Tell the human:

```
Task <N> done: <one-line summary>
Verification: passed (<command/test>)
Files touched: <list>
Tasks remaining: <count> (<count> until next checkpoint)
```

DO NOT auto-continue to the next task. The human says "continue" or names
the next task. Auto-continuing defeats the checkpoint discipline.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll do tasks 3 and 4 together — they're related" | Related is not the same as one task. The tasks list said two; honor the contract. If they truly should be one, amend the tasks file FIRST, then do the merged task. The amendment is the audit trail. |
| "Verification step is overkill, the code obviously works" | "Obviously works" is the agent's pre-bug framing of every bug. Run the verification. The cost is seconds; the savings are bugs caught at the smallest possible diff. |
| "I'll keep going past the checkpoint, the human will catch up later" | Checkpoints exist because the next step is irreversible or expensive to undo. Skipping a checkpoint to save time is exactly the trade SDD prevents. STOP at every one. |
| "I'll fix the small thing in the adjacent file while I'm here" | The small thing belongs to a different change OR a different task. Either way, smuggling it into this task corrupts the diff and breaks the audit trail. Amend the tasks file or skip the small thing. |
| "Updating the tasks file is busywork — the diff shows what I did" | The tasks file is the resumption point for the next session. A stale tasks file means the next session re-does work or skips work. Cheap to keep current; expensive to debug otherwise. |
| "I'll commit all the tasks together at the end" | One commit per task is the SDD contract. Big commits hide which task introduced which behavior, defeat bisect, and produce code-review fatigue. One task, one commit. |

## Red Flags

- Multiple tasks marked `[x]` but only one commit landed
- Files touched in the diff exceed the task's Files touched list (without an amendment)
- Verification step skipped or replaced with "looks right"
- Agent moved past a CHECKPOINT without an explicit "pass" from the human
- Tasks file unchanged after the work landed (no `[x]`, no Notes update)
- Diff includes "while I'm here" cleanup unrelated to the task
- Task failed verification but is marked `[x]` anyway
- New tasks invented and executed without going through tasks-file amendment first

## Verification

- [ ] Exactly ONE task picked per apply invocation
- [ ] The picked task was the first unchecked item in tasks.md (not skipped over)
- [ ] If a CHECKPOINT was reached, execution stopped and waited for human
- [ ] Diff is contained to the task's Files touched list (or the list was amended first)
- [ ] Task's Verify step ran and PASSED before the box was checked
- [ ] tasks.md updated: box checked, Notes appended if any deviation
- [ ] Implementation + tasks-file update committed together with the SDD message format
- [ ] Reported back to human; did NOT auto-continue to the next task

## When done

Nothing to update in `.launchpad/manifest.yml` — sdd-apply is a lifecycle
skill and produces commits + an updated tasks.md, not a project artifact.

Next likely skills:
- `lifecycle:sdd-apply` — the next task, after the human says continue
- `lifecycle:sdd-verify` — when all tasks are checked, validate against the spec
- `lifecycle:sdd-tasks` — if a task amendment grew large enough to warrant re-planning the remaining work
