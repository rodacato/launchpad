#!/usr/bin/env bash
set -e

echo "→ Setting up project environment..."

# Git safe directory
git config --global --add safe.directory /workspace 2>/dev/null || true

# GitHub CLI auth check (non-blocking)
if gh auth status &>/dev/null; then
  echo "  ✓ GitHub CLI authenticated"
else
  echo "  ! GitHub CLI not authenticated — run: gh auth login"
fi

# Claude Code version check
if command -v claude &>/dev/null; then
  echo "  ✓ Claude Code $(claude --version 2>/dev/null || echo 'installed')"
else
  echo "  ! Claude Code not found — check devcontainer features"
fi

# Copy .env.example if .env doesn't exist
if [ -f .env.example ] && [ ! -f .env ]; then
  cp .env.example .env
  echo "  ✓ .env created from .env.example"
fi

echo "→ Setup complete. See README.md for next steps."
