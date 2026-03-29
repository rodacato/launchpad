# Launchpad Adoption Checklist

> This file was created by `adopt.sh`. Work through it, then delete it.
> Unlike START_HERE.md (for new projects), this assumes your project already
> exists with code, docs, and history. We're adding the launchpad process layer.

---

## What was already set up

The adopt script downloaded:
- `.launchpad/` — base workflow, agent roles, sync tooling
- `.github/workflows/` — enforce-issue-link, pr-labels
- `.github/ISSUE_TEMPLATE/` — bug, feature, research (if missing)
- `AGENTS.md` — project-level agent overrides (if missing)
- `docs/WORKFLOW.md` — project-level workflow customizations (if missing)

---

## Manual setup

### 1. CLAUDE.md — add launchpad fields

If your project has a `CLAUDE.md`, add these fields to `## Project identity`:

```
**GitHub Project Number**: <!-- from gh project list --owner {org} -->
```

Add to `## How to start a session`:

```
1. Read `.launchpad/WORKFLOW.md` (base process) then `docs/WORKFLOW.md` (project specifics)
```

If your project doesn't have a `CLAUDE.md`, create one based on the template.

### 2. docs/WORKFLOW.md — customize for your project

Open `docs/WORKFLOW.md` and fill in:
- [ ] Documentation map (update file locations to match your project)
- [ ] Definition of done (testing, linting, type checking commands)
- [ ] Test strategy (layers, what to mock, commands)
- [ ] Project-specific playbooks (if any)

### 3. AGENTS.md — customize for your project

Open `AGENTS.md` and add:
- [ ] Project-specific rules (things the agent should never do in THIS project)
- [ ] Additional triggers (project-specific commands)
- [ ] Extra roles (if you have agents beyond the base Team Lead + Research)

### 4. GitHub configuration

- [ ] Create labels (if they don't exist):
      ```
      gh label create "feature" --color "0E8A16" --description "New functionality" --force
      gh label create "bug" --color "D73A4A" --description "Something broken" --force
      gh label create "research" --color "0075CA" --description "Explore before building" --force
      gh label create "chore" --color "CFD3D7" --description "Maintenance, deps, config" --force
      gh label create "blocked" --color "B60205" --description "Waiting on something external" --force
      gh label create "agent:active" --color "5319E7" --description "Agent is working this" --force
      gh label create "agent:review" --color "FBCA04" --description "Agent opened PR, waiting review" --force
      ```

- [ ] Configure merge strategy (if not already set):
      ```
      gh api repos/{owner}/{repo} --method PATCH \
        -f allow_squash_merge=true \
        -f allow_merge_commit=false \
        -f allow_rebase_merge=false \
        -f squash_merge_commit_title="PR_TITLE" \
        -f squash_merge_commit_message="PR_BODY" \
        -f delete_branch_on_merge=true
      ```

- [ ] Enable project board automations (if you have a project board):
      ```
      Open the project board → menu (⋯) → Workflows
      1. "Auto-add to project" → select this repo → save
      2. "Item closed" → set status to "Done" → save
      3. "Pull request merged" → set status to "Done" → save
      ```

- [ ] Protect main branch (if not already protected):
      ```
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

### 5. Verify

- [ ] Run `.launchpad/sync.sh` — should say "Everything up to date"
- [ ] Open a test PR — enforce-issue-link should check for `closes #N`
- [ ] Start a new agent session — it should follow the startup behavior from `.launchpad/AGENTS.md`

### 6. Commit and clean up

```bash
git add -A && git commit -m "chore: adopt launchpad template"
rm ADOPT.md
git add -A && git commit -m "chore: remove adoption checklist"
```

---

> After this, your project is part of the launchpad ecosystem.
> Future updates: `.launchpad/sync.sh` to check, `.launchpad/sync.sh --apply` to update.
