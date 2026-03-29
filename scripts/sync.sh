#!/usr/bin/env bash
set -euo pipefail

# Launchpad Sync — update .launchpad/ markdown files from the template repo
#
# Usage (from any launchpad project root):
#   curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/sync.sh | bash
#
# What it does:
#   - Compares local .launchpad/ version against the remote
#   - If outdated, downloads updated .launchpad/*.md files
#   - Never touches files outside .launchpad/ — those are project-owned
#
# To leave launchpad entirely: rm -rf .launchpad/

MANIFEST=".launchpad/manifest.yml"

if [[ ! -f "$MANIFEST" ]]; then
  echo "Error: $MANIFEST not found. Is this a launchpad project?"
  echo "To adopt launchpad, run:"
  echo "  curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/adopt.sh | bash"
  exit 1
fi

SOURCE=$(grep '^source:' "$MANIFEST" | awk '{print $2}')
BRANCH=$(grep '^branch:' "$MANIFEST" | awk '{print $2}')
LOCAL_VERSION=$(grep '^version:' "$MANIFEST" | awk '{print $2}' | tr -d '"')

echo "Launchpad Sync"
echo "Local:  v$LOCAL_VERSION"

# Fetch remote manifest
REMOTE_MANIFEST=$(gh api "repos/$SOURCE/contents/.launchpad/manifest.yml?ref=$BRANCH" --jq '.content' 2>/dev/null | base64 -d 2>/dev/null) || {
  echo "Error: could not reach $SOURCE. Check your network and gh auth."
  exit 1
}
REMOTE_VERSION=$(echo "$REMOTE_MANIFEST" | grep '^version:' | awk '{print $2}' | tr -d '"')
echo "Remote: v$REMOTE_VERSION"
echo ""

if [[ "$LOCAL_VERSION" == "$REMOTE_VERSION" ]]; then
  echo "Everything up to date."
  exit 0
fi

echo "Update available: v$LOCAL_VERSION → v$REMOTE_VERSION"
echo ""

# Files that live in .launchpad/ — the ONLY things we sync
FILES=(
  ".launchpad/AGENTS.md"
  ".launchpad/WORKFLOW.md"
  ".launchpad/ADOPT.md"
  ".launchpad/manifest.yml"
)

UPDATES=0

for file in "${FILES[@]}"; do
  REMOTE_CONTENT=$(gh api "repos/$SOURCE/contents/$file?ref=$BRANCH" --jq '.content' 2>/dev/null | base64 -d 2>/dev/null) || {
    echo "  SKIP  $file (not found in template)"
    continue
  }

  if [[ ! -f "$file" ]]; then
    echo "  NEW   $file"
    mkdir -p "$(dirname "$file")"
    echo "$REMOTE_CONTENT" > "$file"
    UPDATES=$((UPDATES + 1))
    continue
  fi

  LOCAL_CONTENT=$(cat "$file")
  if [[ "$LOCAL_CONTENT" != "$REMOTE_CONTENT" ]]; then
    echo "  UPDATE  $file"
    echo "$REMOTE_CONTENT" > "$file"
    UPDATES=$((UPDATES + 1))
  fi
done

echo ""
if [[ $UPDATES -eq 0 ]]; then
  echo "Files already match remote (version updated)."
else
  echo "$UPDATES file(s) updated."
fi
echo ""
echo "Review changes: git diff .launchpad/"
echo "Commit: git add .launchpad/ && git commit -m 'chore: sync launchpad to v$REMOTE_VERSION'"
