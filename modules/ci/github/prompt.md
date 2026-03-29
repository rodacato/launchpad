# Module: github

## What this installs

`.github/` — GitHub configuration:

- `workflows/enforce-issue-link.yml` — fails PRs missing `closes #N`
- `workflows/pr-labels.yml` — syncs `agent:active` / `agent:review` on PR open/merge
- `workflows/pages.yml` — GitHub Pages deploy (optional)
- `ISSUE_TEMPLATE/` — feature, bug, research, chore templates
- `PULL_REQUEST_TEMPLATE.md`

Also configures: labels, project board, merge strategy, branch protection.

## Before you start

```bash
ls .github/ 2>/dev/null || echo "not found"
gh auth status
gh repo view --json name,owner
```

---

## Steps

### Step 1 — Copy GitHub files

The template files live in the launchpad repo at `modules/ci/github/`.
Fetch and copy any missing files:

```bash
BASE="https://raw.githubusercontent.com/rodacato/launchpad/master/modules/ci/github"
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

### Step 5 — Merge strategy (optional)

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

### Step 6 — Branch protection (after first push to main)

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

---

## When done

Update `.launchpad/manifest.yml`:
- Add `github: "1.0"` under `modules:`

Then delete `LAUNCHPAD_TASK.md`.
