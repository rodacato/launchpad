---
name: sdd-verify
description: SDD-lite step 5 — validates the implementation against the accepted spec and plan. Reports CRITICAL / WARNING / SUGGESTION findings with citations to specific success criteria, then either approves the change or sends it back for fixes. Use after sdd-apply marks all tasks done. Use before opening the PR for a substantial change. NOT a code review (use lifecycle:review for that) — this is a spec-fit check.
metadata:
  version: "0.1"
---

# SDD Verify

## Overview

Step 5 of SDD-lite. Reads `spec.md`, `plan.md`, `tasks.md`, and the
implementation diff. Reports findings against each spec success criterion:

- **CRITICAL** — the change does not satisfy a spec success criterion or violates a constraint
- **WARNING** — the change satisfies the criterion but in a way the plan didn't anticipate, or with a risk not in the plan's risk table
- **SUGGESTION** — non-blocking improvement; implementation could ship but the change is worth the team's attention

Verdict: **APPROVE** (no CRITICALs) or **REQUEST CHANGES** (one or more
CRITICALs). Fix the CRITICALs before opening the PR.

This is NOT a code review. It's a spec-fit check — does the change deliver
what the spec said it would? `lifecycle:review` is the multi-axis quality
review that runs after the PR exists.

## When to Use

- `sdd-apply` marked all tasks `[x]` and the change is implementation-complete
- About to open the PR and want a final spec-fit gate before reviewers see it
- A PR was opened and the human asks "did we actually deliver the spec?"
- Re-running after CRITICALs were addressed to confirm fixes landed

**When NOT to use:**
- The implementation isn't done yet — sdd-apply isn't complete
- You want a code-quality review — that's `lifecycle:review`
- You want to evaluate the design itself — that's a re-read of the plan, not verify
- The change shipped without SDD — there's no spec to verify against; do `lifecycle:review` instead

## Before you start

Required: all four artifacts present and the implementation in a known
state (committed or staged).

```bash
cat docs/sdd/<change-name>/spec.md   # status: accepted
cat docs/sdd/<change-name>/plan.md   # status: accepted
cat docs/sdd/<change-name>/tasks.md  # all [x]
git diff <base-branch>...HEAD --stat # the change as a single diff
```

If any artifact is missing or any task is unchecked: STOP. Tell the human
which step needs to complete first. Don't verify against a partial
implementation.

## Process

### Step 1 — Re-load the spec criteria

Open `spec.md` and extract:

- Every bullet from the "Success criteria" section (these are the things
  the change must do)
- Every constraint from "Constraints" (the things the change must not
  violate)
- Every item from "Out of scope" (the things the change must not include)

Write them into a working list — each item gets a verdict by the end.

### Step 2 — Walk the diff against the criteria

For each success criterion: find the code change that satisfies it. Cite
the file and line(s). If you can't find the code that satisfies it, that's
a CRITICAL.

For each constraint: find evidence the constraint is respected. Common
checks:
- Performance: a benchmark, a measurement, a comment explaining the bound
- Security: an auth check, an input validator, a permission gate
- Compatibility: tests covering the pre-change behavior still pass

For each out-of-scope item: scan the diff for any code that touches it. If
you find code touching out-of-scope, that's a CRITICAL or WARNING
depending on intent.

### Step 3 — Walk the diff against the plan

Compare the actual files touched (from `git diff --stat`) against the
plan's "Module / file changes" section. Discrepancies:

- Files in the plan but NOT in the diff → unimplemented portion → CRITICAL
- Files in the diff but NOT in the plan → unplanned work → WARNING (was the plan amended?)
- Key decisions in the plan not visible in the code → either WARNING (implicit) or CRITICAL (contradicted)

### Step 4 — Walk the diff against the risks

Each risk in the plan's "Risks and mitigations" table:

- Was the mitigation actually implemented in the code?
- Did the implementation introduce a NEW risk not in the table? → WARNING

### Step 5 — Format findings

Group by severity. Each finding has a stable shape:

```
[CRITICAL] <one-line summary>
- Spec / Plan / Tasks reference: <quote>
- Code reference: <file:line>
- Why it fails: <one to three sentences>
- Suggested fix: <concrete action>

[WARNING] <one-line summary>
- ... (same shape)

[SUGGESTION] <one-line summary>
- ... (same shape)
```

If a section has no findings, say so explicitly — empty sections are
information. ("CRITICAL findings: none.")

### Step 6 — Render the verdict

```
=== SDD Verify — <change-name> ===

Spec: docs/sdd/<change-name>/spec.md (accepted, <N> success criteria)
Plan: docs/sdd/<change-name>/plan.md (accepted, <N> file changes planned)
Tasks: docs/sdd/<change-name>/tasks.md (<N>/<N> done)

CRITICAL findings: <count>
WARNING findings: <count>
SUGGESTION findings: <count>

Verdict: APPROVE | REQUEST CHANGES

<if APPROVE>
The implementation satisfies every spec success criterion, respects every
constraint, and stays inside the out-of-scope boundary. Open the PR.

<if REQUEST CHANGES>
The implementation does not yet satisfy the spec. Address the CRITICAL
findings above and re-run /lifecycle:sdd-verify <change-name>.
</if>
```

### Step 7 — Persist the verdict

Append the verdict to `tasks.md` under a `## Verification` section, with
the timestamp and the verdict. Future runs of the change (if it's
re-opened or audited) need this record.

```markdown
## Verification

- 2026-04-15 — APPROVE (CRITICAL: 0, WARNING: 1, SUGGESTION: 2)
- 2026-04-14 — REQUEST CHANGES (CRITICAL: 2, WARNING: 0, SUGGESTION: 1)
  - resolved: <one-line per CRITICAL fix>
```

Commit the tasks-file update: `docs(sdd): record verify result for
<change-name>`.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll skip verify — the tests pass" | Tests verify the WHAT-the-code-does, not the WHAT-the-spec-asked-for. The spec might have asked for something tests don't cover (a non-functional requirement, a specific UX, an out-of-scope boundary). Verify checks spec-fit; tests check correctness. Both matter. |
| "Verify and review do the same thing" | They don't. Verify is "does this implement the spec?" Review is "is this code well-written?" A change can pass verify and fail review (works but ugly), or pass review and fail verify (clean code, wrong feature). Run both. |
| "WARNING isn't blocking, I'll ignore them" | WARNINGs aren't blocking but they're information. Each one represents a deviation from the plan or a new risk. Ignoring them silently grows the gap between SDD artifacts and reality. Address or document the call. |
| "The spec was approximate, I'll relax CRITICAL findings" | If the spec was approximate, the spec needed amendment BEFORE apply. Relaxing CRITICAL findings post-hoc is the same as having no spec. Either fix the implementation or amend the spec officially and re-verify. |
| "I can verify and ship in one go" | Verify is the gate before ship. Skipping it means the first time anyone checks "did we deliver?" is in production. The cheapest moment to find a CRITICAL is right now, before the PR. |
| "I'll write the verdict in chat, not in tasks.md" | Chat is ephemeral. The tasks.md verification record is the audit trail for "when did this change satisfy its spec?". Without it, the next person re-runs verification from scratch. |

## Red Flags

- Verdict rendered without iterating through every spec success criterion
- CRITICAL findings present but verdict is APPROVE
- Verify ran against an implementation that has unchecked tasks
- Out-of-scope items touched in the diff with no acknowledgment
- Files in the diff that aren't in the plan — and no plan amendment visible
- "Suggested fix" is missing on a CRITICAL or vague ("rewrite this")
- Verdict not appended to tasks.md (no audit trail)
- Re-run after fixes claims APPROVE without re-checking each previously CRITICAL finding
- Verify treated as a code review (started commenting on style, naming, refactor opportunities) — that's lifecycle:review's job

## Verification

- [ ] All four artifacts exist and are in the expected state (specs/plan accepted, all tasks `[x]`)
- [ ] Every spec success criterion was checked individually with a code reference
- [ ] Every constraint was checked with explicit evidence
- [ ] Every out-of-scope item was confirmed absent from the diff
- [ ] Plan's "Module / file changes" was walked against the actual diff
- [ ] Plan's risks table was walked — mitigations confirmed in code
- [ ] Findings formatted with severity / Spec ref / Code ref / Why / Suggested fix
- [ ] Verdict matches the findings (APPROVE iff CRITICAL count is zero)
- [ ] Verdict appended to tasks.md `## Verification` section with timestamp
- [ ] tasks.md update committed: `docs(sdd): record verify result for <change-name>`

## When done

Nothing to update in `.launchpad/manifest.yml` — sdd-verify is a lifecycle
skill and produces a verdict + an updated tasks.md, not a project
artifact.

Next likely skills:
- `lifecycle:git-workflow` + `lifecycle:review` — open the PR and run a code-quality review (verify gated spec-fit; review gates code health)
- `lifecycle:sdd-apply` — if REQUEST CHANGES, fix the CRITICALs, then re-run sdd-verify
- `lifecycle:ship` — only after the PR merges and the change is ready to release
