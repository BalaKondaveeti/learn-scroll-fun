#!/bin/sh
# Blocks a push if the outgoing commits contain a GitHub token.
# Usage: sh scripts/scan-secrets.sh [revision-range]   (default: everything not on origin)
set -e
range="${1:-}"
if [ -z "$range" ]; then
  if git rev-parse --verify -q origin/main >/dev/null; then range="origin/main..HEAD"; else range="HEAD"; fi
fi
# Pattern is split so this file never matches itself.
pattern='gh[pousr]_[A-Za-z0-9]{20,}'
if git log -p --format='%H %s%n%b' "$range" | grep -E -q "$pattern"; then
  echo "Push blocked: a GitHub token pattern was found in $range" >&2
  exit 1
fi
if git diff --cached | grep -E -q "$pattern"; then
  echo "Commit blocked: a GitHub token pattern is staged" >&2
  exit 1
fi
echo "No tokens found in $range"
