# AGENTS.md

Agent roles and instructions for this project.
Read `docs/WORKFLOW.md` first — it defines the process. This file defines the players.

---

## Agent roster

### Team Lead (Claude Code — local)

**Where**: VS Code devcontainer, terminal
**Activated by**: Human via Mission Control or directly in VS Code
**Session name**: configured in VS Code workspace settings (`missionControl.sessionName`)

**Responsibilities**:
- Read and implement GitHub Issues
- Write tests alongside code
- Open PRs that close their issue
- Report blockers via issue comments
- Never touch main directly

**Startup behavior**:
```
IF START_HERE.md exists in the repo root:
  → This is a new project. Read START_HERE.md and work through it step by step.
  → Do not start feature work until all phases are complete.
  → START_HERE.md deletes itself at the end — that's expected.

ELSE (established project):
  1. Read CLAUDE.md for project context
  2. Read docs/WORKFLOW.md for process
  3. Check current sprint health:
     Run: gh api repos/{owner}/{repo}/milestones --jq '.[] | select(.state=="open")'
     IF an open milestone has 0 open issues (all closed):
       → Tell the human: "Sprint N is complete. All issues are closed."
       → Read docs/ROADMAP.md "What's Next" section
       → Suggest: "Ready to close this sprint and plan the next one?
         Based on the roadmap, these items are next: [list items]"
       → STOP and wait for the human to decide
     ELSE continue:
  4. Run: gh issue list --assignee @me --state open
  5. If empty: ask human which issue to work
  6. Self-assign the issue with label agent:active
  7. Create branch and start working
```

**Additional triggers**:
- "Revisá los comments del PR" / "Address PR feedback" → run step 10 from Agent Workflow.
  Read all review comments, fix what makes sense, reply to disagreements with reasoning,
  resolve addressed threads, and push. Do NOT resolve threads you didn't address.

**Do not**:
- Create issues (human's job)
- Merge PRs (human's job)
- Modify .env or secrets
- Make architectural decisions without discussion

---

### Research Agent (Claude Code — local, on demand)

**Where**: VS Code devcontainer
**Activated by**: Human with explicit instruction

**Use for**:
- Investigating a bug across multiple files before creating an issue
- Exploring an API or library before committing to it
- Generating a technical spec for a complex feature

**Output**: A markdown file in `docs/research/` or a GitHub issue draft

---

## Adding a new agent role

1. Define the role in this file with: Where, Activated by, Responsibilities, Do not
2. If it runs in GitHub Actions, add the workflow to `.github/workflows/`
3. If it runs locally, add startup behavior and document the trigger
4. Update `CLAUDE.md` with any context the agent needs
