#!/usr/bin/env bash
# Builds the app with grammar enabled, screenshots all tabs + grammar flow,
# then reverts the grammar flag. Run from the repo root.
set -e

REPO="$(cd "$(dirname "$(realpath "$0")")/../.." && pwd)"
PORT=8767
GRAMMAR_SCREEN="$REPO/manabi_do/lib/presentation/screens/grammar/grammar_screen.dart"
export NODE_PATH="$REPO/scripts/screenshot/pw/node_modules"
PW_DIR="$REPO/scripts/screenshot/pw"

if [ ! -d "$PW_DIR/node_modules/playwright" ]; then
  echo "→ installing Playwright"
  mkdir -p "$PW_DIR"
  cd "$PW_DIR" && npm install playwright 2>&1 | tail -2
  npx playwright install chromium 2>&1 | tail -2
  echo "✓ Playwright ready"
fi

cleanup() {
  echo "→ reverting _grammarEnabled"
  sed -i 's/const _grammarEnabled = true/const _grammarEnabled = false/' "$GRAMMAR_SCREEN"
}
trap cleanup EXIT

echo "→ enabling grammar"
sed -i 's/const _grammarEnabled = false/const _grammarEnabled = true/' "$GRAMMAR_SCREEN"

bash "$REPO/scripts/run/run-web.sh" "$PORT"

echo "→ screenshotting tabs"
node "$REPO/scripts/screenshot/screenshot_tab.js" "$PORT"

echo "→ screenshotting grammar"
node "$REPO/scripts/screenshot/screenshot_grammar.js" "$PORT"

echo "✓ done — screenshots in screenshot/output/"
