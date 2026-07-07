#!/usr/bin/env bash
# Builds the app with grammar enabled, screenshots all tabs + grammar flow,
# then reverts the grammar flag. Run from the repo root.
set -e

REPO="$(cd "$(dirname "$0")/.." && pwd)"
PORT=8767
GRAMMAR_SCREEN="$REPO/manabi_do/lib/presentation/screens/grammar/grammar_screen.dart"
export NODE_PATH="$REPO/scripts/pw/node_modules"

bash "$REPO/scripts/setup.sh"

cleanup() {
  echo "→ reverting _grammarEnabled"
  sed -i 's/const _grammarEnabled = true/const _grammarEnabled = false/' "$GRAMMAR_SCREEN"
}
trap cleanup EXIT

echo "→ enabling grammar"
sed -i 's/const _grammarEnabled = false/const _grammarEnabled = true/' "$GRAMMAR_SCREEN"

bash "$REPO/scripts/build_web.sh" "$PORT"

echo "→ screenshotting tabs"
node "$REPO/scripts/screenshot/screenshot_tab.js" "$PORT"

echo "→ screenshotting grammar"
node "$REPO/scripts/screenshot/screenshot_grammar.js" "$PORT"

echo "✓ done — screenshots in screenshots/"
