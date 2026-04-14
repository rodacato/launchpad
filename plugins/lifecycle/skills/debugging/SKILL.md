---
name: debugging
description: Executes a systematic debugging process — reproduce, isolate, hypothesize, test, fix, regression-test. Use when something is broken and the cause isn't obvious. Use when a fix was attempted and the bug came back. Use when the agent is tempted to "try things" instead of reasoning. Use when an error message is loud but vague. Refuses to ship a fix without a regression test for the failure mode.
metadata:
  version: "0.1"
---

# Debugging

## Overview

A systematic debugging process the agent runs when something is broken and
the fix isn't obvious. The bar: every fix is paired with a regression test
that would have caught the bug had it existed before. Fixes without
regression tests are bugs waiting to recur.

The skill exists to break the agent's worst debugging habit: pattern-matching
the error message to a "common cause" and changing code until the symptom
goes away. That's not debugging — that's gambling.

## When to Use

- A test, build, or feature is broken and the cause isn't immediately obvious from a one-line trace
- A previous fix appears to have come back (regression)
- The agent finds itself about to "try something and see what happens"
- Error message is technically descriptive but doesn't point at the actual cause
- Intermittent / flaky behavior where reproduction itself is the puzzle
- The human asks "why is this happening?" — that question alone earns this skill

**When NOT to use:**
- Single-line typo or syntax error where the fix is mechanical
- Lint / format errors — those are not bugs, they're hygiene
- Working code being asked "is this right?" — that's a review, not a debug
- Investigating a feature you haven't built yet (that's design, not debug)

## Before you start

Required: the failing thing — a test name, a reproduction command, a stack
trace, a screenshot, a URL. If the human says "it's broken" with no
artifact, ask for one before starting. Debugging without a reproduction is
storytelling.

```bash
# Common starting points
git log --oneline -10            # what changed recently?
git diff HEAD~5 --stat           # recent footprint
gh pr list --state merged --limit 5
```

If a test is failing, run it once with verbose output and pin the exact
output BEFORE you change anything. You'll need it later to confirm the fix.

## Process

### Step 1 — Reproduce

Make the bug happen on demand. If you can't reproduce, you can't fix.

- Capture the EXACT command, input, environment that triggers it
- If intermittent: run 10 times, count failures, note any pattern
- If environment-specific: name the environment ("only on macOS arm64",
  "only when DB has > 1000 rows", "only with node 20")

If you cannot reproduce after a focused effort, STOP and tell the human:
"I can't reproduce. Here's what I tried. Can you give me the exact steps,
or pair on it?" Don't fabricate a fix for a bug you can't trigger.

### Step 2 — Isolate

Find the smallest input / state that still triggers the bug.

- Comment out half the path, retry — does it still fail?
- Mock the slow / external thing, retry — does it still fail?
- Strip the inputs to minimum, retry — does it still fail?

Goal: shrink the surface area to one function, one branch, one line. The
isolation step is where most "mysterious" bugs reveal themselves.

### Step 3 — Hypothesize

Write down (or state) a SPECIFIC theory of what's wrong. Format:

```
HYPOTHESIS: <concrete claim about cause>
EVIDENCE FOR: <what you've observed that supports it>
EVIDENCE AGAINST: <what would falsify it>
TEST: <the specific check that confirms or denies>
```

Bad hypothesis: "something is wrong with the auth middleware."
Good hypothesis: "the JWT library returns a different shape when `exp` is
missing — line 47 of auth.ts assumes it always has `exp` and crashes on
the optional path."

### Step 4 — Test the hypothesis BEFORE changing code

Confirm the hypothesis with a check that doesn't require a fix:

- Add a `console.log` / `print` / breakpoint at the suspected line
- Run the reproduction
- Read the actual values
- Confirm: does what you observed match what the hypothesis predicted?

If YES → proceed to Step 5.
If NO → return to Step 3 with new evidence. Don't push forward with a
disproven hypothesis "in case it works anyway."

### Step 5 — Apply the smallest possible fix

The fix should be the smallest change that resolves the confirmed cause.

- Don't refactor adjacent code "while you're in there"
- Don't add error handling for cases unrelated to the bug
- Don't introduce a new abstraction "to prevent this in future"

If you spot something else that needs fixing, name it in a separate
follow-up — don't smuggle it into the bug fix.

### Step 6 — Write the regression test

Before declaring the bug fixed, write a test that:

1. Would have failed BEFORE your fix
2. Passes AFTER your fix
3. Targets the specific failure mode (not just "the feature works")

If the project has no test framework, the regression check might be a
manual reproduction step added to a CHECKS.md or to the issue. Document
the verification however the project allows; don't skip it.

Verify the test by reverting your fix locally, running the test, watching
it fail, then re-applying the fix and watching it pass. This is the proof
the test actually targets the bug.

### Step 7 — Verify the original reproduction

Run the EXACT reproduction from Step 1. The output should now match the
expected behavior. Don't declare done based on "the test passes" alone —
the test can be wrong; the original reproduction is the ground truth.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll just try changing X and see if it helps" | If you're trying things, you don't have a hypothesis. Stop, isolate, form a specific theory, then test it. Trying-things is a path to multiple coincidental fixes that don't address the cause. |
| "The error message says X so the fix is obviously Y" | Error messages name the SYMPTOM, not the cause. The cause is usually one or two layers up the stack. Pattern-matching the message is exactly how you fix the wrong line. |
| "I can't reproduce reliably so I'll fix it speculatively" | A speculative fix you can't verify is a guess. Either keep digging until reproduction is reliable, OR tell the human you can't reproduce and don't ship a fix you can't validate. |
| "Adding a regression test takes too long" | The bug took longer. Without the test, the next refactor reintroduces the bug and someone debugs it from scratch. The regression test pays for itself the first time it catches a recurrence. |
| "The fix is one line, it can't break anything else" | One-line fixes have a notorious blast radius because nobody re-runs the full test suite for "obvious" changes. Run the suite. |
| "I'll add error handling around the bug to silence it" | Silencing an error converts a loud bug into a silent one. Find and fix the cause; only add error handling for cases you intentionally want to tolerate. |

## Red Flags

- Agent changes code before stating a hypothesis
- "Fix" is shipped without a regression test AND no explanation of why a test isn't possible
- Multiple changes in the bug-fix commit beyond what the cause requires
- Hypothesis was disproven mid-process and the agent kept going anyway
- Agent declares "done" based on a derived signal (test passes) without re-running the original reproduction
- Reproduction step was skipped because "the bug is obvious"
- Fix adds error handling that converts a crash into silent wrong behavior
- Multiple "this might be it" attempts in sequence, each making changes — that's not debugging, that's flailing

## Verification

- [ ] The original reproduction (from Step 1) was captured BEFORE any code changes
- [ ] The reproduction now passes / behaves correctly with the fix applied
- [ ] A regression test exists that fails without the fix and passes with it
- [ ] The test was confirmed to actually target the bug by reverting the fix locally and watching the test fail
- [ ] The fix is the minimum change that resolves the confirmed cause — no adjacent refactors or unrelated cleanup
- [ ] If the cause turned out to be different from the initial hypothesis, the actual cause is documented (commit body or issue comment)

## When done

Nothing to update in `.launchpad/manifest.yml` — `debugging` is a lifecycle
skill and produces a fix + a regression test, not a project artifact.

Next likely skills:
- `lifecycle:git-workflow` — commit the fix + regression test cleanly
- `lifecycle:review` — once a PR exists with the fix, review it
- `lifecycle:simplify` — sanity-check that the fix didn't accidentally over-engineer the surrounding code
