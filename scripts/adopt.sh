#!/usr/bin/env bash
set -euo pipefail

# Launchpad Adopt — add launchpad to an existing project
#
# Usage (from any project root):
#   curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/adopt.sh | bash
#
# What it does:
#   - Creates .launchpad/ with base markdown files (AGENTS.md, WORKFLOW.md, manifest)
#   - Drops ADOPT.md checklist for the agent to work through
#   - Creates project-level AGENTS.md and docs/WORKFLOW.md templates (if missing)
#   - Downloads GitHub workflows and issue templates (if missing)
#   - Never overwrites existing project files
#
# To leave launchpad entirely: rm -rf .launchpad/

SOURCE="${LAUNCHPAD_SOURCE:-rodacato/launchpad}"
BRANCH="${LAUNCHPAD_BRANCH:-master}"
RAW_BASE="https://raw.githubusercontent.com/$SOURCE/$BRANCH"

echo "=== Launchpad Adopt ==="
echo "Source: $SOURCE ($BRANCH)"
echo ""

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: not inside a git repository."
  exit 1
fi

if [[ -f ".launchpad/manifest.yml" ]]; then
  echo "This project already has launchpad. To update, run:"
  echo "  curl -sL $RAW_BASE/scripts/sync.sh | bash"
  exit 0
fi

# Helper: download a file, always overwrite
fetch() {
  local path="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if curl -sfL "$RAW_BASE/$path" -o "$dest"; then
    echo "  OK    $dest"
  else
    echo "  FAIL  $dest"
    return 1
  fi
}

# Helper: download only if file doesn't exist
fetch_if_missing() {
  local path="$1" dest="$2"
  if [[ -f "$dest" ]]; then
    echo "  SKIP  $dest (already exists)"
  else
    fetch "$path" "$dest"
  fi
}

echo "Setting up .launchpad/ (template-managed)..."
echo ""

# These are the ONLY files launchpad owns
fetch ".launchpad/AGENTS.md" ".launchpad/AGENTS.md"
fetch ".launchpad/WORKFLOW.md" ".launchpad/WORKFLOW.md"
fetch ".launchpad/ADOPT.md" ".launchpad/ADOPT.md"
fetch ".launchpad/manifest.yml" ".launchpad/manifest.yml"

echo ""
echo "Setting up project files (yours to customize)..."
echo ""

# Project-level overrides — only if missing
fetch_if_missing "AGENTS.md" "AGENTS.md"
fetch_if_missing "docs/WORKFLOW.md" "docs/WORKFLOW.md"

# GitHub workflows — only if missing
fetch_if_missing ".github/workflows/enforce-issue-link.yml" ".github/workflows/enforce-issue-link.yml"
fetch_if_missing ".github/workflows/pr-labels.yml" ".github/workflows/pr-labels.yml"

# Issue templates — only if missing
fetch_if_missing ".github/ISSUE_TEMPLATE/bug.md" ".github/ISSUE_TEMPLATE/bug.md"
fetch_if_missing ".github/ISSUE_TEMPLATE/feature.md" ".github/ISSUE_TEMPLATE/feature.md"
fetch_if_missing ".github/ISSUE_TEMPLATE/research.md" ".github/ISSUE_TEMPLATE/research.md"
fetch_if_missing ".github/PULL_REQUEST_TEMPLATE.md" ".github/PULL_REQUEST_TEMPLATE.md"

# Move checklist to project root for the agent to find
cp .launchpad/ADOPT.md ADOPT.md
echo "  OK    ADOPT.md (adoption checklist)"

echo ""
echo "=== Done ==="
echo ""
echo "Launchpad owns ONLY .launchpad/ — everything else is yours."
echo ""
echo "Next steps:"
echo "  1. Open the project in VS Code"
echo "  2. Tell the agent: 'read ADOPT.md and work through it'"
echo "  3. The agent will read your project, ask questions, and set everything up"
echo ""
echo "To leave launchpad at any time: rm -rf .launchpad/ ADOPT.md"
echo ""
