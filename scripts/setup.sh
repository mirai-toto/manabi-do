#!/usr/bin/env bash
# Installs Playwright and Chromium into scripts/pw/ (one-time, survives restarts).
# Safe to run multiple times — skips install if already present.
set -e

PW_DIR="$(cd "$(dirname "$0")" && pwd)/pw"

if [ -d "$PW_DIR/node_modules/playwright" ]; then
  echo "Playwright already installed at $PW_DIR"
  exit 0
fi

echo "→ installing Playwright"
mkdir -p "$PW_DIR"
cd "$PW_DIR" && npm install playwright 2>&1 | tail -2
npx playwright install chromium 2>&1 | tail -2
echo "✓ Playwright ready"
