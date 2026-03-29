# Agents

> Defines who works on what and how. Read this at session start.
> Base behavior is defined here. Project-specific overrides are at the bottom.

---

## Agent Roster

### Team Lead (Claude Code — local)

**Where**: VS Code (devcontainer or local)
**Activated by**: Human via IDE or terminal

**Responsibilities**:
- Read and implement GitHub Issues
- Write tests alongside code
- Open PRs that close their issue
- Report blockers via issue comments
- Never touch main directly

**Startup behavior**:
```
1. Read CLAUDE.md for project context
2. Read docs/WORKFLOW.md for process (search: find . -name "WORKFLOW.md" -not -path "*/.git/*")
3. Read AGENTS.md for project-specific rules
4. Check for module updates:
   bash <(curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/check.sh)
   OR read .launchpad/manifest.yml and check versions manually
   If updates available → tell the human, continue regardless
5. Check sprint health:
   gh api repos/{owner}/{repo}/milestones --jq '.[] | select(.state=="open")'
   If open milestone has 0 open issues → tell human "Sprint N is complete, ready to plan next?"
   STOP and wait for human decision
6. gh issue list --assignee @me --state open
7. If empty → ask human which issue to work
8. Self-assign issue with label agent:active, create branch, start working
```

**Additional triggers**:
- "Address PR feedback" → read all review comments on the current PR, fix actionable ones,
  reply to disagreements with reasoning, push, resolve addressed threads

**Do not**:
- Create issues (human's job)
- Merge PRs (human's job)
- Modify .env or secrets
- Make architectural decisions without discussion

---

### Research Agent (Claude Code — on demand)

**Where**: Activated by human with explicit instruction
**Use for**:
- Investigating a bug across multiple files before creating an issue
- Exploring an API or library before committing to it
- Generating a technical spec for a complex feature

**Output**: Markdown in `docs/research/` or a GitHub issue draft

---

## Project-Specific Rules

<!-- Add rules that apply only to this project. Examples:
- Do not modify the billing module without human approval
- Always run migrations in a transaction
- Use the project's custom CLI for deployments
-->

---

## Additional Triggers

<!-- Add project-specific triggers. Examples:
- "Run the data migration" → follow docs/guides/migration-playbook.md
- "Deploy to staging" → follow docs/guides/deploy-playbook.md
-->

---

## Extra Roles

<!-- Add project-specific agent roles here.
     Format: Where, Activated by, Responsibilities, Do not. -->
