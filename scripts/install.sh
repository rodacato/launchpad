#!/usr/bin/env bash
set -euo pipefail

# Launchpad — single entry point
#
# Usage:
#   curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/install.sh | bash
#
# If .launchpad/ exists → sync
# If .launchpad/ doesn't exist → adopt

SOURCE="${LAUNCHPAD_SOURCE:-rodacato/launchpad}"
BRANCH="${LAUNCHPAD_BRANCH:-master}"
RAW_BASE="https://raw.githubusercontent.com/$SOURCE/$BRANCH"

if [[ -f ".launchpad/manifest.yml" ]]; then
  echo "Launchpad detected — syncing..."
  echo ""
  curl -sL "$RAW_BASE/scripts/sync.sh" | bash
else
  echo "Launchpad not found — adopting..."
  echo ""
  curl -sL "$RAW_BASE/scripts/adopt.sh" | bash
fi
