#!/usr/bin/env bash
set -euo pipefail

# Launchpad Adopt — add launchpad template structure to an existing project
#
# Usage (from any project root):
#   curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/.launchpad/adopt.sh | bash
#
# Or with a custom source:
#   curl -sL https://raw.githubusercontent.com/{org}/launchpad/master/.launchpad/adopt.sh | bash

SOURCE="${LAUNCHPAD_SOURCE:-rodacato/launchpad}"
BRANCH="${LAUNCHPAD_BRANCH:-master}"
RAW_BASE="https://raw.githubusercontent.com/$SOURCE/$BRANCH"

echo "=== Launchpad Adopt ==="
echo "Source: $SOURCE ($BRANCH)"
echo ""

# Verify we're in a git repo
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: not inside a git repository."
  exit 1
fi

# Helper: download a file from the template repo
fetch_file() {
  local path="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if curl -sfL "$RAW_BASE/$path" -o "$dest"; then
    echo "  OK    $dest"
  else
    echo "  FAIL  $dest (could not fetch $path)"
    return 1
  fi
}

# Helper: download only if file doesn't exist (project-owned files)
fetch_if_missing() {
  local path="$1"
  local dest="$2"
  if [[ -f "$dest" ]]; then
    echo "  SKIP  $dest (already exists — project-owned)"
  else
    fetch_file "$path" "$dest"
  fi
}

echo "Downloading template-managed files..."
echo ""

# .launchpad/ base files (always overwrite — these are managed)
fetch_file ".launchpad/AGENTS.md" ".launchpad/AGENTS.md"
fetch_file ".launchpad/WORKFLOW.md" ".launchpad/WORKFLOW.md"
fetch_file ".launchpad/manifest.yml" ".launchpad/manifest.yml"
fetch_file ".launchpad/sync.sh" ".launchpad/sync.sh"
chmod +x .launchpad/sync.sh

# GitHub workflows (always overwrite — managed)
fetch_file ".github/workflows/enforce-issue-link.yml" ".github/workflows/enforce-issue-link.yml"
fetch_file ".github/workflows/pr-labels.yml" ".github/workflows/pr-labels.yml"

# GitHub templates (only if missing — project may have custom ones)
fetch_if_missing ".github/ISSUE_TEMPLATE/bug.md" ".github/ISSUE_TEMPLATE/bug.md"
fetch_if_missing ".github/ISSUE_TEMPLATE/feature.md" ".github/ISSUE_TEMPLATE/feature.md"
fetch_if_missing ".github/ISSUE_TEMPLATE/research.md" ".github/ISSUE_TEMPLATE/research.md"
fetch_if_missing ".github/PULL_REQUEST_TEMPLATE.md" ".github/PULL_REQUEST_TEMPLATE.md"

echo ""
echo "Creating project-level files (if missing)..."
echo ""

# Project-level AGENTS.md (thin override — only if missing)
fetch_if_missing "AGENTS.md" "AGENTS.md"

# Project-level docs/WORKFLOW.md (thin override — only if missing)
fetch_if_missing "docs/WORKFLOW.md" "docs/WORKFLOW.md"

echo ""
echo "Downloading adoption checklist..."
echo ""

# Drop the adoption checklist
fetch_file ".launchpad/ADOPT.md" "ADOPT.md"

echo ""
echo "=== Done ==="
echo ""
echo "Next steps:"
echo "  1. Review changes: git diff"
echo "  2. Read ADOPT.md for remaining manual setup"
echo "  3. Commit: git add -A && git commit -m 'chore: adopt launchpad template'"
echo "  4. Delete ADOPT.md when done"
echo ""
