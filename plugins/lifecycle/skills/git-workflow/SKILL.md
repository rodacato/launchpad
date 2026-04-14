---
name: git-workflow
description: Executes git hygiene — branch from issue, commit with conventional format, open a PR that closes the issue, never push to default. Use when about to start work on an issue and a branch doesn't exist yet. Use when about to commit and the message format isn't obvious. Use when opening a PR and the format is unclear. Use when you're tempted to push to main or skip hooks. Reads the project's CLAUDE.md / AGENTS.md / CONTRIBUTING.md first to honor project-specific overrides.
metadata:
  version: "0.1"
---

# Git Workflow

## Overview

Executes the project's git hygiene from one well-defined entry point:
branch → commit → PR. Reads project conventions FIRST (CLAUDE.md, AGENTS.md,
CONTRIBUTING.md) so it honors per-project overrides instead of imposing a
default. Refuses destructive operations without explicit human confirmation.

The bar is correctness, not speed. A messy commit history is debt the next
person — usually you in three months — will pay.

## When to Use

- About to start work on an issue and the branch hasn't been created yet
- Files are staged or about to be staged and the commit format isn't obvious
- About to open a PR and you need to write title, body, and link the issue
- Tempted to push to `main` / `master` directly — STOP and load this
- Tempted to use `--no-verify`, `--force`, or `git rebase -i` without a clear
  rollback plan — STOP and load this
- The agent doesn't know whether to amend or create a new commit

**When NOT to use:**
- Trivial typo fix on a doc-only branch where conventions already obvious
- Read-only git operations (`git log`, `git status`, `git diff`) — those don't need workflow
- The project explicitly opts out of this skill in CLAUDE.md (it does not exist today, but document the override if it comes)

## Before you start

Read these in order. Each one can override the defaults in this skill:

```bash
fd CLAUDE.md --exclude .git --max-depth 2
fd AGENTS.md --exclude .git --max-depth 2
fd CONTRIBUTING.md --exclude .git --max-depth 2
```

Surface what the project actually says about:
- Commit message format (Conventional Commits? plain? prefix scheme?)
- Branch naming convention
- PR template / required body sections
- Whether `closes #N` / `fixes #N` is required and where
- Co-authored-by attribution policy (kwik-e-marketplace: NEVER add it)
- Any rules about default branch name (`main` vs `master`)

If the project has zero conventions documented, fall back to the defaults
in this skill but flag it to the human: "no conventions found in
CLAUDE.md/AGENTS.md/CONTRIBUTING.md; using defaults — add them if you want
something else."

## Process

### Step 1 — Branch from the issue

If the work is tied to an issue (it almost always is for feature work):

```bash
gh issue view <N>             # confirm assignee, title, labels
git checkout <default-branch> # main or master, per project
git pull
git checkout -b issue-<N>-<short-kebab-description>
```

Branch naming: the kwik-e-marketplace convention is
`issue-<N>-<short-description>` (per CLAUDE.md). Other projects may differ —
honor what their CONTRIBUTING.md says.

If there's no issue (e.g. trivial doc fix the human authorized):
- Use a descriptive branch like `docs/fix-typo-in-readme`
- Be ready to justify to the human why no issue exists

### Step 2 — Commit with the project's format

Default for kwik-e-marketplace and most rodacato projects:

```text
type(scope): short imperative description

Optional body explaining WHY (not what — the diff shows what).
Wrap at 72 chars.
```

Where:
- `type` ∈ feat | fix | docs | refactor | test | chore
- `scope` is plugin / module / area (project-specific)

**Always:**
- Imperative mood ("add", "fix", "remove" — not "added", "adds")
- One concern per commit; if you can't summarize in one short line, split
- Body explains the WHY when it isn't obvious from the diff

**Never:**
- Co-Authored-By trailers (per CLAUDE.md / AGENTS.md)
- "Generated with Claude" or any AI attribution
- `--amend` to a commit that's already on a remote branch where someone might be reviewing
- `--no-verify` to skip hooks; if a hook fails, fix the underlying issue

For multi-line bodies use the heredoc pattern:

```bash
git commit -m "$(cat <<'EOF'
type(scope): short description

Body paragraph explaining the why.
EOF
)"
```

### Step 3 — Open the PR

```bash
git push -u origin HEAD       # first push of the branch
gh pr create \
  --base <default-branch> \
  --title "<short title under 70 chars>" \
  --body "$(cat <<'EOF'
## Summary
- bullet 1
- bullet 2

## Test plan
- [ ] item 1
- [ ] item 2

closes #<N>
EOF
)"
```

PR title rules:
- Mirror the commit message style (`type(scope): description`)
- Under 70 characters
- Imperative mood
- NO emojis unless the project explicitly uses them

PR body rules:
- ALWAYS include `closes #<N>` / `fixes #<N>` (whichever the project uses)
  so the issue closes on merge — per CLAUDE.md, this is mandatory for
  feature work and AGENTS forbids closing issues manually
- Summary as bullets — keep it scannable
- Test plan as a checklist — actual checks the human (or you) will run

### Step 4 — Handle pre-commit / pre-push hook failures

Order of operations when a hook fails:

1. READ the hook output — what specifically failed?
2. Fix the underlying issue (lint error, type error, test failure)
3. Re-stage the fix and re-commit (NOT `--amend` — the failed commit didn't happen)
4. NEVER bypass with `--no-verify` unless the human explicitly asked AND you've explained the risk

### Step 5 — Destructive operations require human confirmation

These ALWAYS require an explicit "yes do that" from the human:

- `git push --force` / `--force-with-lease`
- `git reset --hard` on anything other than your own un-pushed branch
- `git rebase` of commits that are already on a shared branch
- `git branch -D` of unmerged work
- `git clean -fd` in a dirty tree
- Closing or deleting a PR

State the operation, the consequence, and wait. Cheap to ask, expensive to
reverse.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "It's a tiny fix, no issue needed" | If it's worth committing it's worth tracking. CLAUDE.md says "never start work without an issue number for feature work." Doc typos are the exception, not the rule. |
| "I'll amend the last commit instead of adding a new one" | If the commit is already pushed and someone might be reviewing, amend rewrites their reference. Default to a NEW commit; reserve amend for unpushed work you authored seconds ago. |
| "Pre-commit hook is wrong, I'll skip it" | The hook exists because someone hit the bug it catches. Investigate before bypassing. If the hook is genuinely broken, fix the hook in a separate commit. |
| "I'll squash-merge so messy history doesn't matter" | Squash-merging hides the bad commits at merge time but they still polluted the PR diff during review. Clean commits make review faster AND survive squash. |
| "Force-push is fine, it's my branch" | "Your" branch is shared the moment a reviewer opens it. Force-push without a heads-up to the reviewer breaks their state and surprises them. Use `--force-with-lease` minimum, and announce. |
| "I'll add Co-Authored-By Claude — it's honest" | Project policy (CLAUDE.md, AGENTS.md) says NEVER. The reason is signal: the humans want commits to read as their work product, not as collaborations with a tool. |

## Red Flags

- About to push to `main` / `master` for feature work
- Commit message doesn't follow the project's documented format
- Commit body contains "Co-Authored-By", "Generated with", or any AI attribution
- PR body lacks `closes #N` / `fixes #N` for issue-tracked work
- Branch name doesn't follow the project's convention
- About to use `--no-verify`, `--force`, `--amend` on pushed commits, or `reset --hard` without explicit human go-ahead
- Multiple unrelated changes in a single commit (mixed concerns)
- Hook failed, agent fixed the surface symptom, agent re-commits without understanding the root cause
- PR title is longer than 70 characters or contradicts the commit it represents

## Verification

- [ ] CLAUDE.md / AGENTS.md / CONTRIBUTING.md were checked for project-specific overrides BEFORE the first git command ran
- [ ] Branch name matches the project's convention (kwik-e-marketplace: `issue-<N>-<short>`)
- [ ] Commit message matches the project's format (kwik-e-marketplace: `type(scope): description`)
- [ ] Commit message contains NO Co-Authored-By or AI attribution lines
- [ ] PR body contains `closes #<N>` / `fixes #<N>` for issue-tracked work
- [ ] No `--force`, `--no-verify`, `--amend` on pushed commits unless human gave explicit per-action approval
- [ ] `gh pr view <N>` returns a PR with the expected title, body, and base branch
- [ ] If a hook failed: the underlying cause was diagnosed, not bypassed

## When done

Nothing to update in `.launchpad/manifest.yml` — `git-workflow` is a
lifecycle skill and produces an action (a commit, a PR), not a project
artifact.

Next likely skills:
- `lifecycle:review` — once the PR exists, run a review on it
- `lifecycle:simplify` — run on the diff before opening the PR to catch over-engineering
- `lifecycle:ship` — when the work merges and triggers a release
