# Launchpad Adoption Checklist

> **For the agent**: This file guides adoption of the launchpad process into an existing project.
> The project already has code, docs, and history — you are adding the process layer.
>
> **Your approach**: Read the project's existing documentation FIRST to understand context.
> Then fill in the launchpad files using what you learned. Ask the human when something
> is unclear or missing — do NOT guess or leave placeholders.
>
> **Checkpoint rule**: After completing each step, IMMEDIATELY mark its checkbox.

---

## What was already set up

The adopt script downloaded:
- `.launchpad/` — base workflow, agent roles, sync tooling
- `.github/workflows/` — enforce-issue-link, pr-labels
- `.github/ISSUE_TEMPLATE/` — bug, feature, research (if missing)
- `AGENTS.md` — project-level agent overrides (if missing)
- `docs/WORKFLOW.md` — project-level workflow customizations (if missing)

---

## Phase 1 — Understand the project

> Read everything before changing anything. Build your mental model.

- [ ] Read `CLAUDE.md` (if it exists) for project context
- [ ] Read `README.md` for project overview, stack, and purpose
- [ ] Scan the codebase: check `package.json`, `Gemfile`, `go.mod`, `pyproject.toml`,
      or similar to identify the stack, test runner, linter, and type checker
- [ ] Read existing docs: check `docs/` for any architecture, vision, or workflow docs
- [ ] Check git history: `git log --oneline -20` to understand recent work patterns
- [ ] Check GitHub state: `gh issue list --state open`, `gh milestone list`, `gh label list`

Now ask the human to clarify anything you couldn't determine:
- "I found [stack]. Is that the complete stack, or is there more?"
- "I see you have [X issues open]. Are you using milestones/sprints?"
- "Do you have a project board? If so, what's the project number?"
- "Are there any project-specific rules I should know about?"
  (e.g., "never modify the billing module", "always run migrations in a transaction")

**STOP and wait for the human to answer before continuing.**

---

## Phase 2 — Configure CLAUDE.md

- [ ] If `CLAUDE.md` exists, add these fields to `## Project identity` (if missing):
      ```
      **GitHub Project Number**: <!-- ask human or run: gh project list --owner {org} -->
      ```
      Add or update `## How to start a session` to include:
      ```
      1. Read `.launchpad/WORKFLOW.md` (base process) then `docs/WORKFLOW.md` (project specifics)
      ```
      Add to `## Repository structure` the `.launchpad/` directory.

- [ ] If `CLAUDE.md` does NOT exist, create one:
      Fill in Project Identity from what you learned in Phase 1 (name, purpose, stack, stage).
      Ask the human to confirm before writing.

---

## Phase 3 — Customize project workflow

> Use what you learned in Phase 1 to fill these in automatically.
> Show the human your proposed content and wait for approval before writing.

- [ ] **docs/WORKFLOW.md** — Documentation map:
      Read the actual project structure (`ls docs/`, check for README, CHANGELOG, etc.)
      and fill in the documentation map table with real file locations.

- [ ] **docs/WORKFLOW.md** — Definition of done:
      Based on the stack you detected:
      - Find the test command (e.g., from `package.json` scripts, `Makefile`, etc.)
      - Find the lint command
      - Find the type check command (if applicable)
      Fill in the checkboxes with the real commands.

- [ ] **docs/WORKFLOW.md** — Test strategy:
      Based on the architecture:
      - What layers exist? (API, domain, infrastructure, UI)
      - What gets mocked? What uses real dependencies?
      Fill in the table and commands section.

- [ ] **docs/WORKFLOW.md** — Project-specific playbooks:
      Ask the human: "Are there recurring operations specific to this project?"
      (e.g., data migrations, deployments, seed data, environment setup)
      Add them as playbooks if any.

- [ ] **AGENTS.md** — Project-specific rules:
      Based on what you learned, propose rules. Examples:
      - Sensitive areas of the code that need human approval
      - Specific testing requirements
      - Deployment restrictions
      Show the human and ask: "Are there other rules I should follow in this project?"

- [ ] **AGENTS.md** — Additional triggers:
      Ask the human: "Are there project-specific commands you want me to respond to?"
      (e.g., "deploy to staging", "run the data migration", "generate API docs")

Show all proposed content to the human and wait for approval before writing.

---

## Phase 4 — GitHub configuration

> Some of these may already be configured. Check first, skip what exists.

- [ ] Check existing labels: `gh label list`
      Create only the labels that don't already exist (do NOT use --force — it overwrites custom colors):
      ```
      # Only create if missing — check gh label list output first
      gh label create "feature" --color "0E8A16" --description "New functionality" 2>/dev/null || true
      gh label create "bug" --color "D73A4A" --description "Something broken" 2>/dev/null || true
      gh label create "research" --color "0075CA" --description "Explore before building" 2>/dev/null || true
      gh label create "chore" --color "CFD3D7" --description "Maintenance, deps, config" 2>/dev/null || true
      gh label create "blocked" --color "B60205" --description "Waiting on something external" 2>/dev/null || true
      gh label create "agent:active" --color "5319E7" --description "Agent is working this" 2>/dev/null || true
      gh label create "agent:review" --color "FBCA04" --description "Agent opened PR, waiting review" 2>/dev/null || true
      ```
      If a label already exists, the command is silently skipped.

- [ ] Check merge strategy: `gh api repos/{owner}/{repo} --jq '.allow_squash_merge'`
      If not configured, ask the human their preference and apply:
      ```
      gh api repos/{owner}/{repo} --method PATCH \
        -f allow_squash_merge=true \
        -f allow_merge_commit=false \
        -f allow_rebase_merge=false \
        -f squash_merge_commit_title="PR_TITLE" \
        -f squash_merge_commit_message="PR_BODY" \
        -f delete_branch_on_merge=true
      ```

- [ ] Check branch protection: `gh api repos/{owner}/{repo}/rulesets`
      If main is not protected, ask the human if they want protection and apply:
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

- [ ] Check for project board: `gh project list --owner {org}`
      Ask the human: "Do you have a project board for this project?"
      If no, ask: "Do you want one?" and create it:
      ```
      gh project create --owner {org} --title "{Project Name} Board" --format board
      ```
      Update `CLAUDE.md` → `GitHub Project Number` with the project number.

- [ ] Project board automations — tell the human:
      ```
      If you have a project board, enable these automations:
      Open the project board → menu (⋯) → Workflows
      1. "Auto-add to project" → select this repo → save
      2. "Item closed" → set status to "Done" → save
      3. "Pull request merged" → set status to "Done" → save
      ```

---

## Phase 5 — Bootstrap first sprint (optional)

> Ask the human if they want to set up a sprint. Skip this phase if they prefer to start manually.

- [ ] Ask the human: "Do you want to set up a sprint now?
      If you have a roadmap, backlog, or know what to work on next, I can create
      a milestone and initial issues so the workflow is ready to go."
      **STOP and wait for the human to decide. If they say no, skip to Phase 6.**

- [ ] Create the first milestone — ask for sprint name and duration:
      ```
      gh api repos/{owner}/{repo}/milestones \
        -f title="Sprint 1 — {description}" \
        -f due_on="YYYY-MM-DDT00:00:00Z"
      ```

- [ ] Create issues based on what the human wants to work on:
      Ask: "What are the first 3-5 things you want to tackle?"
      For each item:
      ```
      gh issue create --title "..." --body "..." --label "feature" \
        --milestone "Sprint 1 — {description}"
      ```

- [ ] If the project has a board, add issues to it:
      ```
      gh project item-add {PROJECT_NUMBER} --owner {org} \
        --url https://github.com/{owner}/{repo}/issues/{N}
      ```

- [ ] Report: "Sprint 1 created with N issues. The agent workflow will pick these up
      on the next session."

---

## Phase 6 — Verify and commit

- [ ] Verify sync works:
      ```
      curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/install.sh | bash
      ```
      Should say "Everything up to date"
- [ ] Verify workflows exist:
      - `.github/workflows/enforce-issue-link.yml`
      - `.github/workflows/pr-labels.yml`
- [ ] Review all changes: `git diff` and `git status`
- [ ] Commit: `git add -A && git commit -m "chore: adopt launchpad template"`
- [ ] Delete this file: `git rm ADOPT.md && git commit -m "chore: remove adoption checklist"`
- [ ] Tell the human: "Launchpad adopted. The agent workflow is now active.
      Future template updates: curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/install.sh | bash"

---

> After this, the project is part of the launchpad ecosystem.
> Future updates: `curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/install.sh | bash`
