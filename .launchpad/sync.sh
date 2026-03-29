#!/usr/bin/env bash
set -euo pipefail

# Launchpad Template Sync
# Checks for updates from the launchpad template repo and applies them.
# Usage:
#   .launchpad/sync.sh          # check for updates (dry run)
#   .launchpad/sync.sh --apply  # apply updates

MANIFEST=".launchpad/manifest.yml"
APPLY=false

if [[ "${1:-}" == "--apply" ]]; then
  APPLY=true
fi

if [[ ! -f "$MANIFEST" ]]; then
  echo "Error: $MANIFEST not found. Is this a launchpad project?"
  exit 1
fi

# Parse source repo and branch from manifest
SOURCE=$(grep '^source:' "$MANIFEST" | awk '{print $2}')
BRANCH=$(grep '^branch:' "$MANIFEST" | awk '{print $2}')

if [[ -z "$SOURCE" || -z "$BRANCH" ]]; then
  echo "Error: could not parse source/branch from $MANIFEST"
  exit 1
fi

# Parse versions
LOCAL_VERSION=$(grep '^version:' "$MANIFEST" | awk '{print $2}' | tr -d '"')

echo "Checking updates from $SOURCE ($BRANCH)..."
echo "Local version: $LOCAL_VERSION"

# Fetch remote manifest to compare versions
REMOTE_MANIFEST=$(gh api "repos/$SOURCE/contents/.launchpad/manifest.yml?ref=$BRANCH" --jq '.content' 2>/dev/null | base64 -d 2>/dev/null) || {
  echo "Error: could not fetch remote manifest from $SOURCE"
  exit 1
}
REMOTE_VERSION=$(echo "$REMOTE_MANIFEST" | grep '^version:' | awk '{print $2}' | tr -d '"')
echo "Remote version: $REMOTE_VERSION"
echo ""

if [[ "$LOCAL_VERSION" == "$REMOTE_VERSION" ]]; then
  echo "Everything up to date (v$LOCAL_VERSION)."
  exit 0
fi

echo "Update available: v$LOCAL_VERSION → v$REMOTE_VERSION"
echo ""

# Parse managed files from manifest
MANAGED_FILES=$(awk '/^managed:$/,0' "$MANIFEST" | grep '^ *- ' | sed 's/^ *- //')

UPDATES=0
ERRORS=0

for file in $MANAGED_FILES; do
  # Fetch the file from the source repo
  REMOTE_CONTENT=$(gh api "repos/$SOURCE/contents/$file?ref=$BRANCH" --jq '.content' 2>/dev/null | base64 -d 2>/dev/null) || {
    echo "  SKIP  $file (not found in template)"
    continue
  }

  if [[ ! -f "$file" ]]; then
    echo "  NEW   $file"
    UPDATES=$((UPDATES + 1))
    if $APPLY; then
      mkdir -p "$(dirname "$file")"
      echo "$REMOTE_CONTENT" > "$file"
      echo "        → created"
    fi
    continue
  fi

  LOCAL_CONTENT=$(cat "$file")

  if [[ "$LOCAL_CONTENT" != "$REMOTE_CONTENT" ]]; then
    echo "  UPDATE  $file"
    UPDATES=$((UPDATES + 1))
    if $APPLY; then
      echo "$REMOTE_CONTENT" > "$file"
      echo "          → updated"
    fi
  fi
done

echo ""
if [[ $UPDATES -eq 0 ]]; then
  echo "Everything up to date."
else
  echo "$UPDATES file(s) with available updates."
  if ! $APPLY; then
    echo ""
    echo "Run '.launchpad/sync.sh --apply' to apply updates."
    echo "Then review changes with 'git diff' before committing."
  else
    echo ""
    echo "Updates applied (v$LOCAL_VERSION → v$REMOTE_VERSION)."
    echo "Review changes with 'git diff' before committing."
    echo "Suggested commit: git commit -am 'chore: sync template from launchpad v$REMOTE_VERSION'"
  fi
fi
