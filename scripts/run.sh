#!/usr/bin/env bash
# Launchpad module runner
# Usage: bash <(curl -sL https://raw.githubusercontent.com/rodacato/launchpad/master/scripts/run.sh) <module>
# Example: bash <(curl -sL ...) experts

set -euo pipefail

LAUNCHPAD_SOURCE="rodacato/launchpad"
LAUNCHPAD_BRANCH="master"
RAW_BASE="https://raw.githubusercontent.com/${LAUNCHPAD_SOURCE}/${LAUNCHPAD_BRANCH}"

MODULE="${1:-}"

# Module categories and their members
DOCS_MODULES="vision identity experts architecture branding roadmap workflow agents notdefined"
CI_MODULES="github"
INFRA_MODULES="devcontainer kamal caddy"
PROCESS_MODULES="releasing contributing changelog"

ALL_MODULES="${DOCS_MODULES} ${CI_MODULES} ${INFRA_MODULES} ${PROCESS_MODULES}"

# Resolve module name to category/name path
resolve_module() {
  local name="$1"
  # Already a path (e.g. docs/vision)
  if [[ "$name" == */* ]]; then echo "$name"; return; fi
  # Search in each category
  for cat in docs ci infra process; do
    case "$cat" in
      docs)    echo "$DOCS_MODULES" | grep -qw "$name" && echo "docs/$name" && return ;;
      ci)      echo "$CI_MODULES" | grep -qw "$name" && echo "ci/$name" && return ;;
      infra)   echo "$INFRA_MODULES" | grep -qw "$name" && echo "infra/$name" && return ;;
      process) echo "$PROCESS_MODULES" | grep -qw "$name" && echo "process/$name" && return ;;
    esac
  done
  echo ""
}

# Map module -> output path
module_output() {
  case "$1" in
    docs/vision)       echo "docs/VISION.md" ;;
    docs/identity)     echo "docs/IDENTITY.md" ;;
    docs/experts)      echo "docs/EXPERTS.md" ;;
    docs/architecture) echo "docs/ARCHITECTURE.md" ;;
    docs/branding)     echo "docs/BRANDING.md" ;;
    docs/roadmap)      echo "docs/ROADMAP.md" ;;
    docs/workflow)     echo "docs/WORKFLOW.md" ;;
    docs/agents)       echo "AGENTS.md" ;;
    docs/notdefined)   echo ".notdefined.yml" ;;
    ci/github)         echo ".github/" ;;
    infra/devcontainer) echo ".devcontainer/" ;;
    infra/kamal)       echo "config/deploy.yml" ;;
    infra/caddy)       echo "Caddyfile" ;;
    process/releasing) echo "docs/guides/releasing.md" ;;
    process/contributing) echo "CONTRIBUTING.md" ;;
    process/changelog) echo "CHANGELOG.md" ;;
    *)                 echo "(varies)" ;;
  esac
}

usage() {
  cat <<EOF

Launchpad — modular project setup

Usage:
  bash <(curl -sL https://raw.githubusercontent.com/${LAUNCHPAD_SOURCE}/${LAUNCHPAD_BRANCH}/scripts/run.sh) <module>

Docs modules:
  vision        Project compass: problem, philosophy, litmus test
  identity      Build persona: decision style, quality bar, anti-patterns
  experts       Expert advisory panel for cross-cutting decisions
  architecture  System design, tech stack, domain model
  branding      Name, voice, visual identity, design tokens
  roadmap       Phases, milestones, backlog, decision log
  workflow      Team process, test strategy, playbooks
  agents        Agent roles and startup behavior

CI/GitHub modules:
  github        Labels, workflows, issue templates, project board

Infrastructure modules:
  devcontainer  Dev environment (Claude Code + gh + language toolchain)
  kamal         Kamal deployment config
  caddy         Caddy reverse proxy config

Process modules:
  releasing     Release process guide and tooling
  contributing  CONTRIBUTING.md and contribution guidelines

Groups (run multiple modules):
  concept       vision + identity + experts
  technical     architecture + roadmap
  process       workflow + agents

To check which modules are installed:
  bash <(curl -sL https://raw.githubusercontent.com/${LAUNCHPAD_SOURCE}/${LAUNCHPAD_BRANCH}/scripts/check.sh)

EOF
}

# No argument
if [ -z "$MODULE" ]; then
  usage
  exit 1
fi

# Handle groups
case "$MODULE" in
  concept)
    echo "→ Running group: concept (vision, identity, experts)"
    for m in vision identity experts; do
      bash <(curl -sL "${RAW_BASE}/scripts/run.sh") "$m"
    done
    exit 0
    ;;
  technical)
    echo "→ Running group: technical (architecture, roadmap)"
    for m in architecture roadmap; do
      bash <(curl -sL "${RAW_BASE}/scripts/run.sh") "$m"
    done
    exit 0
    ;;
  process)
    echo "→ Running group: process (workflow, agents)"
    for m in workflow agents; do
      bash <(curl -sL "${RAW_BASE}/scripts/run.sh") "$m"
    done
    exit 0
    ;;
esac

# Resolve to category/name
MODULE_PATH=$(resolve_module "$MODULE")

if [ -z "$MODULE_PATH" ]; then
  echo "Error: Unknown module '$MODULE'"
  usage
  exit 1
fi

echo "→ Launchpad: preparing module '$MODULE'..."

# Fetch remote version
REMOTE_VERSION=$(curl -sL "${RAW_BASE}/modules/${MODULE_PATH}/VERSION" 2>/dev/null | tr -d '[:space:]' || echo "unknown")

# Check local manifest
MANIFEST=".launchpad/manifest.yml"
LOCAL_VERSION="not installed"
MODULE_KEY="${MODULE_PATH//\//-}"  # docs/vision -> docs-vision for manifest key
if [ -f "$MANIFEST" ]; then
  # Try short name first (experts), then full path key (docs-experts)
  SHORT_NAME="${MODULE_PATH##*/}"
  EXTRACTED=$(grep "  ${SHORT_NAME}:" "$MANIFEST" 2>/dev/null | sed 's/.*:[ ]*"\?\([^"]*\)"\?[ ]*/\1/' | tr -d '[:space:]' || true)
  if [ -z "$EXTRACTED" ]; then
    EXTRACTED=$(grep "  ${MODULE_KEY}:" "$MANIFEST" 2>/dev/null | sed 's/.*:[ ]*"\?\([^"]*\)"\?[ ]*/\1/' | tr -d '[:space:]' || true)
  fi
  if [ -n "$EXTRACTED" ]; then
    LOCAL_VERSION="$EXTRACTED"
  fi
fi

# Check output file status
OUTPUT_FILE=$(module_output "$MODULE_PATH")
if [ -f "$OUTPUT_FILE" ] || [ -d "$OUTPUT_FILE" ]; then
  FILE_STATUS="exists"
else
  FILE_STATUS="not found"
fi

# Fetch prompt
PROMPT=$(curl -sL "${RAW_BASE}/modules/${MODULE_PATH}/prompt.md" 2>/dev/null || true)

if [ -z "$PROMPT" ]; then
  echo "Error: Could not fetch module '$MODULE' — check your internet connection."
  exit 1
fi

# Build context header
SHORT_NAME="${MODULE_PATH##*/}"
HEADER="# Launchpad Task: ${SHORT_NAME}
> Generated $(date '+%Y-%m-%d %H:%M') | Module: ${MODULE_PATH} | Version: ${REMOTE_VERSION} | Installed: ${LOCAL_VERSION}

## Project state at task generation time

"

# Append relevant file info
for f in CLAUDE.md docs/VISION.md docs/IDENTITY.md docs/EXPERTS.md docs/ARCHITECTURE.md docs/ROADMAP.md docs/WORKFLOW.md AGENTS.md .launchpad/manifest.yml; do
  if [ -f "$f" ]; then
    HEADER="${HEADER}- \`${f}\` exists"$'\n'
  fi
done

HEADER="${HEADER}
- Target output: \`${OUTPUT_FILE}\` (${FILE_STATUS})
- After completing, update \`${SHORT_NAME}\` version in \`.launchpad/manifest.yml\` under \`modules:\`

---

"

# Write LAUNCHPAD_TASK.md
printf '%s\n%s' "$HEADER" "$PROMPT" > LAUNCHPAD_TASK.md

echo ""
echo "✓ LAUNCHPAD_TASK.md ready"
echo ""
echo "  Module:    ${MODULE_PATH}"
echo "  Version:   ${REMOTE_VERSION} (you have: ${LOCAL_VERSION})"
echo "  Target:    ${OUTPUT_FILE} (${FILE_STATUS})"
echo ""
echo "→ Tell Claude Code:"
echo "   \"read LAUNCHPAD_TASK.md and execute it\""
echo ""
