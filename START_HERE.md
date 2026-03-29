# START_HERE.md — Project initialization

> **For the agent**: Read `AGENTS.md` before this file. When starting fresh in this repo,
> work through these steps in order. Check each box as you complete it.
> Do not skip steps. Do not start feature work until all phases are complete.
>
> **Phases 0–2 do NOT require the devcontainer** — they are conversational exploration
> and file editing. Phase 2 ends by configuring the devcontainer based on decisions made.
> **Phases 3–5 run INSIDE the devcontainer** after a rebuild.

> **Checkpoint rule**: After completing each step, IMMEDIATELY mark its checkbox.
> This is your recovery mechanism — if context is lost mid-session, checkboxes
> tell you (or the next agent session) exactly where to resume.

> **Recovery protocol** — if you lose context or start a new session mid-setup:
> 1. Read this file — check which boxes are marked `[x]`
> 2. Read `CLAUDE.md` — if `Stack` is filled, Phase 1 Architecture is done
> 3. Read the last doc in Phase 1 order that has content beyond placeholders
> 4. Resume from the next unchecked item
> 5. Do NOT re-do completed steps — trust the checkboxes and filled docs

---

## Phase 0 — Discovery and Identity Capture

> Understand what we're building. Minimal file edits — just capturing identity.

- [ ] Read `CLAUDE.md`, `docs/WORKFLOW.md`, and `AGENTS.md` for context
- [ ] Ask the human: "What is this project? Name, purpose, one sentence."
- [ ] Ask the human: "Who is it for? What problem does it solve?"
- [ ] Fill in the `## Project identity` section in `CLAUDE.md` (name, purpose, stage).
      Leave `Stack` blank — that gets decided in Architecture (Phase 1).
- [ ] Report to human: "Identity captured. Starting project foundation."

---

## Phase 1 — Project Foundation

> The agent guides the human through each document conversationally.
> Ask questions, propose content, and wait for approval before writing.
> Do NOT fill all docs at once — go one by one, IN THIS ORDER.
> The order matters — each document builds on the ones before it.

> **Checkpoint**: After completing each document, mark its checkbox immediately.
> If this phase spans multiple sessions, the checkboxes indicate where to resume.

- [ ] **Vision** (`docs/VISION.md`):
      This is the project's compass — take your time.
      Explore through conversation: the problem (specific, lived, not abstract),
      the insight (what others are missing), the philosophy (opinionated principles),
      who it's for (concentric circles, plus who it's NOT for),
      what success looks like (honest, not vanity metrics),
      what this is NOT (anti-scope), architecture principles,
      the litmus test (3-5 yes/no questions for every future feature),
      execution strategy (high-level phases), and future ideas backlog.
      Show the full vision and wait for approval.

- [ ] **Build Identity** (`docs/IDENTITY.md`):
      Ask: "What kind of technical leader does this project need?
      What industry experience should they have? What's their decision style?"
      Craft the persona: name, backstory, stack expertise, philosophy,
      decision style, communication voice, quality bar, anti-patterns.
      This becomes the agent's default voice for the project.
      Show the full identity and wait for approval.

- [ ] **Expert Panel** (`docs/EXPERTS.md`):
      Based on the Vision and Identity, propose a panel composition.
      Ask: "Here are the perspectives I think you need — what would you change?"
      Build Core experts (5-7, always active) and Situational experts (2-4, phase-specific).
      Each expert needs: name, backstory, project-specific skills, triggers, voice.
      Build the Quick Reference table and Decision Routing table.
      Show the full panel and wait for approval.
      **This must be done BEFORE Architecture — the experts will be consulted there.**

- [ ] **Architecture** (`docs/ARCHITECTURE.md`):
      Expert-guided exploration — the system blueprint built with the panel.
      Read VISION.md principles first. For each major decision:
      present options, consult relevant experts (Architect, Security, Infra),
      show tradeoffs from each perspective, let the human decide.
      Cover: ecosystem, system overview, tech stack (every choice needs a WHY
      and a rejected alternative), architecture style (DDD? Clean? MVC? Flat?
      — the Architect expert recommends, human decides, DELETE unused sections),
      domain model if applicable (contexts, aggregates, events, ports),
      directory structure, key design decisions, security review.
      Show the full architecture doc and wait for approval.
      **After approval**: update `CLAUDE.md` → `Stack` field with the chosen tech stack.

- [ ] **Roadmap** (`docs/ROADMAP.md`):
      This is the living map — it evolves as the project grows.
      Explore: intent (strategic focus), milestones (defined by outcomes, not dates),
      phases (each with a goal and "does not start until" condition),
      initial "What's Next" features (prioritized, sized S/M/L),
      "Not Doing" (features explicitly rejected, with reasoning and revisit conditions),
      and prioritization principles (3-5 tiebreaker rules).
      History tables (sprints, specs, ADRs) start empty — they fill as work happens.
      Show the initial roadmap and wait for approval.

- [ ] **Branding & Visual Identity** (`docs/BRANDING.md`):
      Creative exploration — this is the project's look, sound, and feel.
      Explore: name (why it works, domain, tagline, alternatives considered),
      brand personality (archetype, traits, voice do's/don'ts, anti-patterns),
      visual identity (palette with design tokens, typography, spacing, style),
      logo concept (2-3 options with reasoning, variants, usage rules),
      microcopy (how the product sounds at key moments),
      and image generation prompts for visual exploration (Stitch, Midjourney, etc.).
      Show the full brand guide and wait for approval.

- [ ] Report to human: "Project foundation complete. Moving to environment setup."

---

## Phase 2 — Environment Configuration

> Still outside the devcontainer. Configure the dev environment based on Architecture decisions,
> then hand off to the human to rebuild.

- [ ] Configure `.devcontainer/devcontainer.json` based on the chosen stack:
      Add the appropriate language features to the `features` section.
      Reference examples are listed as comments in the features block.
      Common features:
      - Ruby → `"ghcr.io/devcontainers/features/ruby:1": { "version": "3.3" }`
      - Python → `"ghcr.io/devcontainers/features/python:1": { "version": "3.12" }`
      - Node → `"ghcr.io/devcontainers/features/node:1": { "version": "22" }`
      - Go → `"ghcr.io/devcontainers/features/go:1": { "version": "1.22" }`
      See https://containers.dev/features for the full catalog.
      The Dockerfile should remain minimal — only add system-level dependencies
      that don't have a devcontainer feature equivalent.
- [ ] Update `.devcontainer/docker-compose.yml` — uncomment services the project needs (db, redis)
- [ ] Update `.env.example` — customize the template based on Architecture decisions:
      - If Postgres enabled → uncomment the database variables
      - If Redis enabled → uncomment the Redis variables
      - Add any app-specific vars the Architecture defined (API keys, ports, etc.)
      - Ensure variable names match what the code will expect
- [ ] Tell the human:
      ```
      Environment configured. Next steps:
      1. Open this project in VS Code
      2. Cmd+Shift+P → "Dev Containers: Rebuild and Reopen in Container"
      3. Wait for the build to complete
      4. Once inside the devcontainer, resume this guide from Phase 3
      ```
      **STOP HERE until the human confirms they are inside the devcontainer.**

      > **Note**: The rebuild starts a new agent session. Follow the Recovery Protocol
      > at the top of this file to determine where to resume.

---

## Phase 3a — Code Scaffold (inside devcontainer)

> From this point on, all work happens INSIDE the devcontainer.
> The agent has access to `gh`, `git`, and the project's full toolchain.

- [ ] Verify the environment:
      ```
      gh auth status
      git --version
      claude --version
      ```
      Then verify the project's stack tools are available
      (commands depend on Architecture choices — examples):
      ```
      ruby --version      # Ruby projects
      node --version      # Node projects
      python3 --version   # Python projects
      go version          # Go projects
      pg_isready -h db    # If Postgres is enabled
      redis-cli -h redis ping  # If Redis is enabled
      ```
      If any required tool is missing or not the expected version, fix it before continuing.
- [ ] **Workflow** (`docs/WORKFLOW.md`):
      The core process (GitHub Issues, Milestones, build cycle) is already defined.
      Customize for this project based on the Architecture:
      fill in the test strategy (layers, what to mock, commands),
      update the definition of done (testing, linting, type checking commands),
      update the documentation map with actual file locations,
      and add any project-specific playbooks.
      Show the customized sections and wait for approval.
- [ ] Scaffold the directory structure defined in `docs/ARCHITECTURE.md`:
      Follow the directory layout from the Architecture doc exactly.
      - Standard project → `src/`, `tests/`, `docs/adr/`, `docs/specs/`
      - Monorepo → `apps/{app}/src/`, `apps/{app}/tests/`, `packages/`, etc.
      - Do NOT create a root `tests/` directory if the architecture uses per-app testing
      Add `.gitkeep` to empty directories so git tracks them.

---

## Phase 3b — GitHub Configuration

> Configure GitHub repository settings, labels, milestones, and initial issues.
> If any GitHub API call fails due to permissions, note it and continue with the rest.
> The human can fix permissions later without blocking other work.

- [ ] Create a GitHub Project for task management:
      Ask the human: "Do you want a project board? What name?"
      ```
      gh project create --owner {org} --title "{Project Name}" --format board
      ```
      Then link the project to the repo (Settings → Projects, or via UI: repo Projects tab → "Link a project"):
      ```
      gh api graphql -f query='
        mutation($projectId:ID!, $repoId:ID!) {
          linkProjectV2ToRepository(input:{projectId:$projectId, repositoryId:$repoId}) {
            repository { id }
          }
        }' -f projectId="{PROJECT_NODE_ID}" -f repoId="{REPO_NODE_ID}"
      ```
      To get the IDs: `gh project list --owner {org} --format json` and `gh repo view --json id`.
      Alternatively, the human can link it manually from the repo's Projects tab.
      This is where sprints, issues, and tasks are visualized.
      **After creating**: update `CLAUDE.md` → `GitHub Project Number` with the project number
      (visible in `gh project list --owner {org}` or in the project URL).
      The agent uses this to move issues between board statuses automatically.
- [ ] Create labels that `docs/WORKFLOW.md` references (use `--force` to update if they already exist):
      ```
      gh label create "feature" --color "0E8A16" --description "New functionality" --force
      gh label create "bug" --color "D73A4A" --description "Something broken" --force
      gh label create "research" --color "0075CA" --description "Explore before building" --force
      gh label create "chore" --color "CFD3D7" --description "Maintenance, deps, config" --force
      gh label create "blocked" --color "B60205" --description "Waiting on something external" --force
      gh label create "agent:active" --color "5319E7" --description "Agent is working this" --force
      gh label create "agent:review" --color "FBCA04" --description "Agent opened PR, waiting review" --force
      ```
- [ ] Create the first milestone — ask human for sprint name and due date:
      `gh api repos/{owner}/{repo}/milestones -f title="Sprint 1 — Foundation" -f due_on="YYYY-MM-DDT00:00:00Z"`
- [ ] Create 3-5 initial issues derived from `docs/ROADMAP.md` "What's Next" section.
      Use `.github/ISSUE_TEMPLATE/feature.md` as the format.
      Ask the human to confirm which items from the roadmap go into Sprint 1.
      Assign all issues to the milestone and add the `feature` label.
- [ ] Ask the human: "Do you want GitHub Pages enabled?"
      If yes, remind them to enable it manually (settings are NOT copied from templates):
      ```
      Human: enable GitHub Pages in the repo settings:
      1. Go to Settings → Pages
      2. Source: select "GitHub Actions"
      3. The workflow at .github/workflows/pages.yml will handle deploys
      ```
      The default workflow deploys `docs/public/` as a static site.
      If the project uses a framework (Next.js, Vite, etc.), customize the workflow
      to add build steps.
      If no, remove `.github/workflows/pages.yml` and `docs/public/`.
- [ ] Verify workflows are present:
      check `.github/workflows/pages.yml` exists (if GitHub Pages was enabled)
- [ ] Report to human: "GitHub setup complete. Moving to finalization."

---

## Phase 4 — Finalize & First Commit

- [ ] Generate `.notdefined.yml` — follow the spec at:
      https://raw.githubusercontent.com/rodacato/rodacato/master/docs/guides/notdefined-yml-spec.md
      Pull values from docs already filled:
      - `tagline` and `description` → from `docs/BRANDING.md` (name section)
      - `color` → from `docs/BRANDING.md` (accent primary color)
      - Stack, status, version → from `CLAUDE.md` and `docs/ARCHITECTURE.md`
      Use `status: active` and `version: "0.1.0"` as starting values.
      Show the human and ask for approval.
- [ ] **LICENSE** — Ask the human: "What license? MIT, Apache 2.0, GPL, or proprietary?"
      Generate the license file. If unsure, recommend MIT for open source or skip for private.
- [ ] **CONTRIBUTING.md** — Generate based on the project's setup:
      - How to set up the dev environment (from `.devcontainer/`)
      - Branch naming and commit conventions (from `docs/WORKFLOW.md`)
      - How to open a PR (from `docs/WORKFLOW.md`)
      - Code style and testing expectations (from `docs/WORKFLOW.md` definition of done)
      Show the human and ask for approval.
- [ ] **SECURITY.md** — Generate a vulnerability reporting policy:
      - How to report (email or GitHub private advisory)
      - What's in scope
      - Expected response timeline
      Ask the human for the security contact email.
      Show and approve.
- [ ] **CODE_OF_CONDUCT.md** — Ask the human: "Do you want a Code of Conduct?"
      If yes, download the Contributor Covenant (do NOT generate it — use curl to avoid content filtering):
      ```
      curl -sL https://www.contributor-covenant.org/version/2/1/code_of_conduct/code_of_conduct.md -o CODE_OF_CONDUCT.md
      ```
      Review the contact method placeholder and ask the human for their preferred contact.
      If no, skip.
- [ ] Update `CLAUDE.md` — sync the repository structure tree to match the actual layout.
      The template structure may no longer match after Architecture decisions
      (e.g., monorepo with `apps/` instead of `src/`). Run `tree -I node_modules -I .git`
      and update the structure block in CLAUDE.md accordingly.
- [ ] Update `README.md`:
      - Replace all placeholder sections with real content from the docs
      - Update the project structure tree to match the actual directory layout
      - Pull the tagline, stack, and description from the filled docs
      - Add license badge if applicable
- [ ] Review all changed files: `git status`
- [ ] Make sure `.env` is in `.gitignore` and NOT staged
- [ ] Commit the initialization:
      `git add -A && git commit -m "chore: initialize project from launchpad"`
- [ ] Push to main: `git push origin main`
- [ ] Configure repository merge strategy — ask the human their preference:
      ```
      # Recommended: squash merge for clean linear history
      gh api repos/{owner}/{repo} --method PATCH \
        -f allow_squash_merge=true \
        -f allow_merge_commit=false \
        -f allow_rebase_merge=false \
        -f squash_merge_commit_title="PR_TITLE" \
        -f squash_merge_commit_message="PR_BODY" \
        -f delete_branch_on_merge=true
      ```
      Options: squash (clean history, recommended), merge commit (preserves branch history),
      rebase (linear but keeps individual commits). Ask which they prefer.
      `delete_branch_on_merge` auto-cleans merged branches — always enable this.
- [ ] Protect the `main` branch (do this AFTER the first push — protection blocks direct pushes):
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
      This requires PRs to merge into main (no direct push) and blocks force pushes.
      `required_approving_review_count: 0` means PRs are required but no approval needed
      (useful for solo devs — the human can adjust this later in Settings → Rules).
- [ ] Report to human: "Project initialized. First sprint has N issues ready. Branch protection is now active — all future changes go through PRs."

---

## Phase 5 — Cleanup

> Final sweep: remove all scaffolding so the repo looks like a real project, not a template.

- [ ] **Verification sweep** — check EVERY doc before cleaning:
      - Scan all `docs/*.md` for unfilled `<!-- placeholder -->` or `<!-- e.g.` comments.
        If any remain, the doc is incomplete — go back and fill it.
      - Verify `CLAUDE.md` has no placeholder fields (name, purpose, stack, stage all filled).
      - Verify `.notdefined.yml` has no `<!-- fill during` comments.
      - Verify `README.md` has no `<!-- placeholder -->` or `<!-- org/repo -->` left.
      - Report any issues to the human before proceeding.
- [ ] Remove `<!-- AGENT INSTRUCTIONS ... -->` blocks from every `docs/*.md` file.
      These are scaffolding for the init process — the filled content speaks for itself.
- [ ] Remove `START_HERE.md` from the `CLAUDE.md` repo structure tree.
- [ ] Remove the `IF START_HERE.md exists` block from `AGENTS.md` startup behavior.
      Keep only the `ELSE` branch (established project flow) as the default.
- [ ] Delete this `START_HERE.md`:
      `git rm START_HERE.md`
- [ ] Commit the cleanup:
      `git add -A && git commit -m "chore: remove initialization scaffolding"`
- [ ] Push: `git push origin main`
- [ ] Tell the human: "Setup complete. Run 'gh issue list' to start the first sprint."

---

> After this phase, this file no longer exists. Future work is tracked in GitHub Issues.
