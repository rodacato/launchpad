---
name: github
description: Configure GitHub — labels, workflows, issue templates, PR template, project board, merge strategy, branch protection. Use when setting up a brand-new repo to match the rodacato process. Use when an existing repo is missing standard labels or templates. Use when enforcing "PRs must reference an issue" across the team. Use when hardening `main` with branch protection after the first push.
metadata:
  version: "1.1"
  author: rodacato
  category: bootstrap
  triggers:
    - github
    - "GitHub setup"
    - labels
    - "issue templates"
    - "PR template"
    - "project board"
    - "branch protection"
    - "gh workflows"
    - ".github directory"
---

# GitHub

## Overview

Configure `.github/` and the GitHub repo settings so the project uses
the rodacato process out of the box — issue templates, PR template,
labels, workflows that enforce issue linkage, an optional project board,
squash-merge strategy, and branch protection on `main`.

## When to Use

- Brand-new repo needs the rodacato `.github/` scaffold applied
- Existing repo is missing standard labels (`feature`, `bug`, `agent:active`, etc.)
- Team wants the "every PR must reference an issue" workflow enforced automatically
- Setting up a Project board with auto-add and "merged → Done" automations
- Hardening `main` with branch protection after the first push

**When NOT to use:**
- Personal throwaway repo that will never see contributors
- Organization-managed templates already handle all of this — don't double-configure
- Private fork where the upstream `.github/` should not be touched

## Before you start

```bash
ls .github/ 2>/dev/null || echo "not found"
gh auth status
gh repo view --json name,owner
```

Required tools: `gh` CLI authenticated, push access to the repo, and
(for project/ruleset calls) appropriate org permissions.

## Process

### Step 1 — Copy GitHub files

The template files live in the launchpad plugin at `skills/github/`.
Fetch and copy any missing files:

```bash
BASE="https://raw.githubusercontent.com/rodacato/launchpad/master/skills/github"
mkdir -p .github/workflows .github/ISSUE_TEMPLATE

# Workflows (ask before overwriting if they exist)
curl -sL "$BASE/workflows/enforce-issue-link.yml" -o .github/workflows/enforce-issue-link.yml
curl -sL "$BASE/workflows/pr-labels.yml"          -o .github/workflows/pr-labels.yml

# Issue templates
curl -sL "$BASE/ISSUE_TEMPLATE/feature.md"  -o .github/ISSUE_TEMPLATE/feature.md
curl -sL "$BASE/ISSUE_TEMPLATE/bug.md"      -o .github/ISSUE_TEMPLATE/bug.md
curl -sL "$BASE/ISSUE_TEMPLATE/research.md" -o .github/ISSUE_TEMPLATE/research.md
curl -sL "$BASE/ISSUE_TEMPLATE/chore.md"    -o .github/ISSUE_TEMPLATE/chore.md
curl -sL "$BASE/ISSUE_TEMPLATE/config.yml"  -o .github/ISSUE_TEMPLATE/config.yml

# PR template
curl -sL "$BASE/PULL_REQUEST_TEMPLATE.md" -o .github/PULL_REQUEST_TEMPLATE.md
```

**If files already exist:** show the diff first, ask before overwriting.

**pages.yml:** Ask: "Do you want GitHub Pages? If yes, what deploys — `docs/public/`, a built app, or something else?"

- If yes → `curl -sL "$BASE/workflows/pages.yml" -o .github/workflows/pages.yml` and customize
- If no → skip

### Step 2 — Labels

```bash
gh label create "feature"      --color "0E8A16" --description "New functionality" --force
gh label create "bug"          --color "D73A4A" --description "Something broken" --force
gh label create "research"     --color "0075CA" --description "Explore before building" --force
gh label create "chore"        --color "CFD3D7" --description "Maintenance, deps, config" --force
gh label create "blocked"      --color "B60205" --description "Waiting on something external" --force
gh label create "agent:active" --color "5319E7" --description "Agent is working this" --force
gh label create "agent:review" --color "FBCA04" --description "Agent opened PR, waiting review" --force
```

### Step 3 — Project board

Ask the human:
- "Do you want a GitHub Project board for this repo?"
- "What name should it have?"

If yes:
```bash
gh project create --owner {org-or-user} --title "{Project Name}" --format board
```

Then show the human how to configure automations in the board UI:
```
Open the project board → click menu (⋯) → Workflows
Enable:
1. "Auto-add to project" → select this repo → save
2. "Item closed" → set status to "Done" → save
3. "Pull request merged" → set status to "Done" → save
```

After creating the board, update `CLAUDE.md` → `GitHub Project Number` field.

### Step 4 — Merge strategy (optional)

Ask: "Do you want to configure the merge strategy? (Recommended: squash merge)"

If yes:
```bash
gh api repos/{owner}/{repo} --method PATCH \
  -f allow_squash_merge=true \
  -f allow_merge_commit=false \
  -f allow_rebase_merge=false \
  -f squash_merge_commit_title="PR_TITLE" \
  -f squash_merge_commit_message="PR_BODY" \
  -f delete_branch_on_merge=true
```

### Step 5 — Branch protection (after first push to main)

```bash
gh api --method POST repos/{owner}/{repo}/rulesets \
  --input - <<'EOF'
{
  "name": "Protect main",
  "target": "branch",
  "enforcement": "active",
  "conditions": { "ref_name": { "include": ["refs/heads/main"], "exclude": [] } },
  "rules": [
    { "type": "pull_request", "parameters": { "required_approving_review_count": 0 } },
    { "type": "non_fast_forward" }
  ]
}
EOF
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Labels are cosmetic, we can add them later" | Later means never. Without labels the `enforce-issue-link` and `pr-labels` workflows have nothing to match on, and triage becomes a manual read of every title. |
| "We don't need issue templates, contributors can figure it out" | Contributors default to one-line issues with no repro. Templates cost five minutes to install and save hours of back-and-forth. |
| "Branch protection blocks me when I need to hotfix" | The ruleset here requires 0 approvals — it only prevents force-push and requires a PR. If that blocks a hotfix, the hotfix is doing something wrong. |
| "Merge commits preserve more history" | They also preserve every WIP commit a contributor pushed. Squash-on-merge gives clean history AND the PR still has the full commit trail. |
| "I'll skip `delete_branch_on_merge`, branches are cheap" | Cheap to create, expensive to read. Stale branches obscure what's live; deletion is reversible via `gh api`. |

## Red Flags

- `.github/workflows/enforce-issue-link.yml` present but `feature`/`bug` labels don't exist — workflow runs and fails on every PR
- Issue templates committed but `config.yml` missing — GitHub shows the raw chooser with no guidance
- Branch protection applied BEFORE the first push to `main` — the rule references a branch that doesn't exist yet, confusing later runs
- `gh label create` run without `--force` on an existing label — silent failure, label unchanged
- Project board created under the wrong owner (personal vs org) — auto-add workflow never fires
- PR template committed with the rodacato default sections stripped out — nothing enforces the "closes #N" convention

## Verification

- [ ] `.github/workflows/enforce-issue-link.yml` and `pr-labels.yml` exist
- [ ] `.github/ISSUE_TEMPLATE/` contains `feature.md`, `bug.md`, `research.md`, `chore.md`, `config.yml`
- [ ] `.github/PULL_REQUEST_TEMPLATE.md` exists and references `closes #N`
- [ ] `gh label list` shows all seven rodacato labels with the documented colors
- [ ] If a Project board was requested: `gh project list --owner <org-or-user>` shows it, and `CLAUDE.md` has the project number filled in
- [ ] If merge strategy was requested: `gh repo view --json allowSquashMerge,allowMergeCommit,allowRebaseMerge` confirms squash-only
- [ ] If branch protection was requested: `gh api repos/{owner}/{repo}/rulesets` lists the "Protect main" ruleset as `active`
- [ ] `.launchpad/manifest.yml` updated with `github: "1.1"` under `modules:`

## When done

Update `.launchpad/manifest.yml` — set `github: "1.1"` under `modules:`.

Next likely skills:
- `kamal` — add a deploy workflow that triggers from tags or `main`
- `vision` / `roadmap` — seed the first issues on the new board
- `devcontainer` — so agent contributors boot into the same environment the workflows assume
