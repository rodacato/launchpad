---
name: code-review
description: Conducts a multi-axis code review on a GitHub PR using the gh CLI. Use when reviewing any PR before merge. Use when evaluating code written by another agent, another person, or yourself. Use when you need to analyze a PR and post structured review comments back to GitHub.
metadata:
  version: "0.1"
---

# Code Review

## Overview

Multi-axis code review on a GitHub PR via the `gh` CLI. Pull the PR, analyze it against five quality axes plus project-specific anti-patterns, then post a structured review with severity-labeled comments back to GitHub. No rubber-stamping — every finding has a file, a line, and a rationale.

**The approval standard:** approve when the change definitively improves codebase health. Perfection is not the bar — continuous improvement is. Don't block a change because it isn't exactly how you would have written it.

## When to Use

- Before merging any PR (human-authored or agent-authored)
- When asked to "review PR #N" or "revisar el PR"
- After completing an `incremental-implementation` slice
- When another model produced code that needs evaluation

**When NOT to use:**
- Dependency-only bumps with no behavior change (verify lockfile and changelog instead)
- Pure formatting / whitespace PRs — use linters
- Drafts explicitly marked as WIP

## Before you start

Required:
- `gh` CLI authenticated (`gh auth status`)
- The PR number or URL

Optional but improves the output:
- `docs/ARCHITECTURE.md` — the DDD / structure contract to check alignment against
- `docs/VISION.md` — the litmus test for feature creep
- The linked issue or plan referenced in the PR body

## Process

### Step 1 — Fetch the PR context

```bash
gh pr view <N> --json title,body,author,files,additions,deletions,labels,headRefOid
gh pr diff <N>
gh pr checks <N>
```

Read carefully:
- **Title and body** — is this ONE thing or many things bundled?
- **File list** — how many distinct capabilities are touched?
- **Description** — does it reference an issue, spec, or plan? If not → flag it immediately.

### Step 2 — Capability sizing (NOT line counting)

Forget line counts. Count **capabilities and responsibilities**:

| Capabilities touched | Verdict |
|---|---|
| 1, clearly scoped | Good — proceed |
| 2-3, tightly related | Acceptable — proceed |
| 4+, OR mixing refactor + feature | **Stop. Ask for a split before continuing.** |

A 500-line PR doing ONE thing well is fine. A 50-line PR mixing four concerns is not.

### Step 3 — Five-axis review

Walk each axis in order. For every finding, record: **file, line, severity, rationale**.

#### 1. Correctness
- Does it match the referenced spec / plan / issue?
- Edge cases handled (null, empty, boundary values)?
- Error paths handled — not just the happy path?
- Tests cover the new behavior? **If zero tests for new logic → Critical.**

#### 2. Readability & Simplicity
- Names consistent with project conventions
- **No generic names** like `data`, `result`, `temp`, `helper`, `utils`, `manager`, `handler` without domain scope
- Linear control flow — no nested ternaries, no deep callbacks
- Methods with more than 3-4 parameters → flag, suggest grouping into a value object
- Methods longer than ~50 lines → flag, ask if it can split into smaller units
- **Any invented concepts outside the established business / domain model → Critical**

#### 3. Architecture (DDD-aware)
- Aligns with `ARCHITECTURE.md`? If the change deviates, the PR body must justify WHY
- Single Responsibility at the FILE level — does this file do one thing?
- Feature creep? Is there work here that was NOT in the linked issue / plan?
- Module boundaries respected (no domain logic in infrastructure, no infra concerns in domain)
- Dependency direction correct (no inward leaks from outer layers)

#### 4. Security
- Input validated at system boundaries
- No secrets in code, logs, or config commits
- Injection risks (SQL, XSS, command)
- External data (APIs, user input, config files) treated as untrusted

#### 5. Performance
- N+1 query patterns
- Unbounded loops or list endpoints without pagination
- Sync operations that should be async
- Unnecessary re-renders in UI components

### Step 4 — Personal red flags (auto-reject triggers)

These are non-negotiable. If ANY is present, the review verdict is **REQUEST_CHANGES**:

- [ ] New methods, classes, or functions without at least one test proving they work
- [ ] Typos in method names, class names, or function names
- [ ] Generic names (`Manager`, `Helper`, `Utils`, `Handler`, `Service`) without domain qualifier
- [ ] New concepts invented outside the established business / domain model
- [ ] Changes that do not match the linked plan / spec with no justification in the PR body

### Step 5 — Compose the review

Label every comment with severity — this tells the author what is required vs optional:

| Prefix | Meaning | Author action |
|---|---|---|
| `Critical:` | Blocks merge | Must fix — security, data loss, auto-reject red flag |
| *(none)* | Required change | Must address before merge |
| `Optional:` | Suggestion | Worth considering |
| `Nit:` | Minor style | Author may ignore |
| `FYI:` | Informational | No action needed |

Draft a **summary body** with:
- One-sentence verdict
- Per-axis findings count (e.g. "Correctness: 2 required, 1 critical. Architecture: 1 required.")
- Top 3 issues ranked by severity

### Step 6 — Post the review via gh CLI

For a review with ONE overall comment (simplest case):

```bash
gh pr review <N> --request-changes --body "<summary>"
# or --approve --body "..."
# or --comment --body "..."
```

For a review with MULTIPLE inline comments (preferred for substantive reviews), use the REST API:

```bash
gh api repos/{owner}/{repo}/pulls/<N>/reviews \
  --method POST \
  -f event="REQUEST_CHANGES" \
  -f body="<summary>" \
  --raw-field 'comments=[
    {"path":"src/foo.ts","line":42,"body":"Critical: no test covers this branch"},
    {"path":"src/foo.ts","line":58,"body":"Nit: rename `data` to something domain-specific"}
  ]'
```

Then verify the review was posted:

```bash
gh pr view <N> --comments
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "It's a small PR, just approve it" | Size doesn't guarantee correctness. Review is binary — apply the process or don't. |
| "The author is senior, they know what they're doing" | Seniors have blind spots too. The review is for the code, not the author. |
| "CI is green, must be fine" | CI catches a fraction of what matters. Architecture, naming, and domain fit are invisible to CI. |
| "Tests pass" | Necessary, not sufficient. Tests can be wrong, incomplete, or testing the wrong thing. |
| "I'll approve and file the cleanup as a separate issue" | Deferred cleanup rarely happens. Require it now, or accept it with explicit written justification. |
| "The AI generated this, it's probably fine" | AI-generated code needs MORE scrutiny, not less. Confident and wrong is a common failure mode. |
| "No tests because it's just glue code" | Glue code is where integration bugs live. No exemption — write the test. |

## Red Flags

- Approving without fetching the diff, running the code, or reading the description
- "LGTM" without per-axis evidence
- Mixing refactor with feature in the same PR
- Any personal red flag present but not blocked
- More than 3-4 distinct responsibilities in one PR
- No link to issue or plan in the PR body
- Method longer than 50 lines with no justification
- Parameters with names like `options` or `config` hiding 6+ unrelated flags
- Generic `Manager`, `Helper`, `Service` without domain qualifier

## Verification

Before declaring the review complete:

- [ ] All 5 axes walked through with at least one observation recorded per axis (or an explicit "no issues")
- [ ] Personal red flags list checked explicitly, not skipped
- [ ] Every finding has a file path, line number, and severity label
- [ ] Review posted via `gh pr review` or the reviews API
- [ ] If `REQUEST_CHANGES` → summary lists the Critical issues upfront
- [ ] If `APPROVE` → summary states what was verified, never just "LGTM"
- [ ] `gh pr view <N> --comments` confirms the review is live on GitHub

## When done

Nothing to update in `.launchpad/manifest.yml` — this is a lifecycle skill, not an installable module. It runs ON projects, not INTO them.

Next likely skills:
- If changes requested → author applies fixes, re-run this skill on the new commits
- If approved → `git-workflow` for merge strategy and commit hygiene
