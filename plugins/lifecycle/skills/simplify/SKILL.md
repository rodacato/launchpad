---
name: simplify
description: Reviews changed code (or a diff) and removes what doesn't earn its keep — dead code, premature abstractions, unnecessary indirection, speculative flexibility, over-defensive guards. Produces concrete deletion suggestions with rationale. Use after writing a feature and before opening the PR. Use when a diff feels too large for what it accomplishes. Use when reviewing code that "works" but feels heavy. Use as a self-audit before declaring a task done.
metadata:
  version: "0.1"
---

# Simplify

## Overview

A pre-PR self-audit that finds code which doesn't earn its keep and proposes
specific deletions. Operates on a diff or a recent change set, not the whole
codebase. The bar: every line, abstraction, and config knob must justify its
existence today — not in a hypothetical future.

The default action is DELETE. Adding code is the easy part; deciding what
not to ship is the harder, more valuable one.

## When to Use

- A feature is implemented and you're about to open the PR — run this on the diff first
- A diff feels disproportionately large for what it accomplishes
- You added "small helpers" or "future-proof" abstractions during implementation
- Reviewing code that works but reads as heavier than the task warranted
- Self-audit before declaring a task done — would a senior engineer trim it?
- You added defensive guards (null checks, try/catch) without a specific failure mode in mind

**When NOT to use:**
- Surface-level formatting / style — that's a linter / formatter
- Functional refactor with a behavior change — that's a feature, not simplification
- Brand-new exploratory code where structure isn't stable yet (simplify before merging, not before iterating)
- Critical-path code with high test coverage and a long history — the "extra" you see may be hard-won regression armor; check before deleting

## Before you start

Required: a clear target — a diff, a PR, or a specific file/function you
just changed.

```bash
# Common targets
git diff                              # uncommitted changes
git diff origin/main...HEAD           # the whole branch vs main
gh pr diff <N>                        # an existing PR
```

Read these for context:
- The relevant `CLAUDE.md` — does the project document any patterns this
  code is supposed to follow? Don't simplify away an intentional pattern.
- `docs/IDENTITY.md` if it exists — the project's tiebreakers (simplicity
  vs performance vs DX) inform what "simpler" means here.

## Process

### Step 1 — Map the diff

Walk the diff and categorize every change as one of:

- **Required by the task** (the actual feature / fix)
- **Glue** (wiring, type signatures, exports — pulled in by required code)
- **Discretionary** (helper, abstraction, defensive guard, config knob, comment, error message — added by your judgment)

The first two stay; the third is the audit target.

### Step 2 — Apply the simplification checklist

For each discretionary change, run the questions below in order. Stop on
the first NO and propose deletion.

#### Dead / unreachable code

- Is this code actually called by any other code in the diff?
- Is the import / export actually used?

If no → delete.

#### Premature abstraction

- Is there a CONCRETE second use case TODAY (not "we might need this")?
- Does the abstraction shorten the code it's used in, or just relocate complexity?
- If you removed the abstraction and inlined the one usage, would the call site become harder to read? (If easier or same → inline, delete the abstraction.)

If you can't name a second concrete use case → inline + delete.

#### Speculative flexibility

- Configuration option / strategy / hook / extension point — is there a CALLER that needs the variability today?
- Is the "what if someone needs X" you're solving a real anticipated requirement, or a hypothetical?

If hypothetical → delete the knob, hardcode the current behavior.

#### Over-defensive guards

- Null check / try/catch / fallback branch — is there a SPECIFIC, observed failure mode it handles?
- Or is it "just in case the input is malformed"?

If the failure mode is hypothetical → delete. Trust internal callers; only validate at system boundaries.

#### Comments that restate the code

- Does this comment explain the WHY (non-obvious rationale, hidden constraint, workaround for a known bug)?
- Or does it explain the WHAT (which the code already says)?

If it's the WHAT → delete.

#### Backward-compat / "in case we need to roll back" code

- Is there an ACTIVE caller of the old behavior?
- Or is it a graveyard of `// removed: see commit X`, `_unused`, `re-export for backwards compat`?

If no active caller → delete.

#### Helper functions used once

- Used in exactly one place + name doesn't dramatically improve readability over the inline expression?

If yes → inline + delete the helper.

### Step 3 — Surface findings to the human

Format each finding as:

```
SIMPLIFICATION CANDIDATE:
- WHAT: <file:line — concrete code to remove>
- WHY: <which checklist question it failed>
- BEFORE: <snippet>
- AFTER: <snippet, or "delete the block entirely">
- RISK: <what could break — usually "nothing today"; sometimes "removes a guard, would surface real bugs">
```

Group findings by file. List the top 5–10. If there are zero, say so explicitly and report "diff is already tight."

### Step 4 — Apply approved deletions

The human picks which to apply. Don't delete unilaterally — the human has
context you don't (planned use cases, team agreements, regulatory
requirements). You propose; they decide.

After applying:
- Re-run tests to confirm nothing broke
- If `lifecycle:debugging` flagged a test was tied to deleted code, ensure the test was actually testing dead behavior, not real behavior

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Better to leave the abstraction in case we need it" | Abstractions cost: every reader has to learn them; every refactor has to navigate them; future use cases rarely match the shape we guessed. The cost is paid daily; the benefit is hypothetical. |
| "I added the null check defensively, it's harmless" | Defensive guards convert loud errors into silent wrong behavior. They're harmful when the input invariant is internal — they hide real bugs. Validate at system boundaries; trust internal contracts. |
| "Comments don't hurt anything" | They do. Stale comments lie. Comments that restate the code rot when the code changes and the comment doesn't. The lying comment is worse than no comment. |
| "I'll leave the helper, maybe someone else will use it" | Discoverability of one-use helpers is bad — the next person re-implements it inline anyway. Code reuse is not the same as code presence. |
| "Removing it now is risky, leave it until we're sure" | "Until we're sure" never arrives. The diff that introduced the questionable code is the moment with the most context — also the cheapest moment to revert it. |
| "The diff feels right because we shipped a complete feature" | Completeness is a feature axis, not a code-quality axis. A complete feature can still be 30% over-engineered. The audit happens AFTER you're sure it works. |

## Red Flags

- Diff includes 3+ "small helpers" and no caller uses any of them more than once
- New configuration option added but no calling code passes a non-default value
- Try/catch around a code path with no documented failure mode
- New abstraction wraps a single call site
- Comments on every other line restating what the code does
- "TODO" or "FIXME" comments added without an issue number
- New file introduced that exports one function used in one place
- Re-exports / barrel files added "for convenience" with no consumer demand

## Verification

- [ ] Every discretionary change in the diff was passed through the Step 2 checklist
- [ ] Findings are formatted as WHAT / WHY / BEFORE / AFTER / RISK
- [ ] If zero findings: explicitly stated as "diff is already tight"
- [ ] No deletion was applied without the human's explicit go-ahead
- [ ] After applying deletions: tests still pass, build still succeeds
- [ ] No simplification removed a behavior the diff was supposed to add

## When done

Nothing to update in `.launchpad/manifest.yml` — `simplify` is a lifecycle
skill and produces deletion proposals + (with approval) the deletions
themselves, not a project artifact.

Next likely skills:
- `lifecycle:git-workflow` — commit the simplifications cleanly
- `lifecycle:review` — open the PR with a tighter diff
- `lifecycle:debugging` — if simplify accidentally surfaced a real bug a guard was hiding
