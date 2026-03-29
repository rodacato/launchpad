#!/usr/bin/env bash
# Launchpad check — shows installed modules and available versions
# Usage: bash <(curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/check.sh)

set -euo pipefail

LAUNCHPAD_SOURCE="rodacato/launchpad"
LAUNCHPAD_BRANCH="master"
RAW_BASE="https://raw.githubusercontent.com/${LAUNCHPAD_SOURCE}/${LAUNCHPAD_BRANCH}"
MANIFEST=".launchpad/manifest.yml"

# category:name pairs
MODULES=(
  "docs:vision"
  "docs:identity"
  "docs:experts"
  "docs:architecture"
  "docs:branding"
  "docs:roadmap"
  "docs:workflow"
  "docs:agents"
  "docs:notdefined"
  "ci:github"
  "infra:devcontainer"
  "infra:kamal"
  "infra:caddy"
  "process:releasing"
  "process:contributing"
  "process:changelog"
)

get_local_version() {
  local name="$1"
  if [ ! -f "$MANIFEST" ]; then echo "—"; return; fi
  local v
  v=$(grep "  ${name}:" "$MANIFEST" 2>/dev/null | sed 's/.*:[ ]*"\?\([^"]*\)"\?[ ]*/\1/' | tr -d '[:space:]' || true)
  echo "${v:-—}"
}

print_group() {
  local category="$1"
  shift
  local entries=("$@")

  echo ""
  echo "  ${category}"
  echo "  $(printf '─%.0s' {1..50})"
  printf "  %-24s %-10s %-10s %s\n" "Module" "Local" "Remote" "Status"

  local prev_cat=""
  for entry in "${entries[@]}"; do
    local cat="${entry%%:*}"
    local name="${entry##*:}"
    [ "$cat" != "$category" ] && continue

    LOCAL=$(get_local_version "$name")
    REMOTE=$(curl -sL "${RAW_BASE}/modules/${cat}/${name}/VERSION" 2>/dev/null | tr -d '[:space:]' || echo "?")

    if [ "$LOCAL" = "—" ]; then
      STATUS="✗ not installed"
    elif [ "$LOCAL" = "$REMOTE" ]; then
      STATUS="✓ up to date"
    else
      STATUS="↑ update ($LOCAL → $REMOTE)"
    fi

    printf "  %-24s %-10s %-10s %s\n" "$name" "$LOCAL" "$REMOTE" "$STATUS"
  done
}

echo ""
echo "Launchpad Module Status"
echo "══════════════════════════════════════════════════════════"

for cat in docs ci infra process; do
  print_group "$cat" "${MODULES[@]}"
done

echo ""

if [ ! -f "$MANIFEST" ]; then
  echo "  No .launchpad/manifest.yml found."
fi

echo "  To install or update:"
echo "  bash <(curl -sL https://raw.githubusercontent.com/${LAUNCHPAD_SOURCE}/${LAUNCHPAD_BRANCH}/scripts/run.sh) <module>"
echo ""
