#!/usr/bin/env bash
# Builds the app with grammar enabled, serves it, runs all screenshot scripts,
# then reverts the grammar flag. Run from the repo root.
set -e

REPO="$(cd "$(dirname "$0")/.." && pwd)"
APP="$REPO/manabi_do"
PORT=8767
GRAMMAR_SCREEN="$APP/lib/presentation/screens/grammar/grammar_screen.dart"
export NODE_PATH=/tmp/pw-test/node_modules

cleanup() {
  echo "→ reverting _grammarEnabled"
  sed -i 's/const _grammarEnabled = true/const _grammarEnabled = false/' "$GRAMMAR_SCREEN"
}
trap cleanup EXIT

echo "→ enabling grammar"
sed -i 's/const _grammarEnabled = false/const _grammarEnabled = true/' "$GRAMMAR_SCREEN"

echo "→ building"
cd "$APP"
flutter build web -t lib/main.dart --no-web-resources-cdn --debug 2>&1 | tail -3

echo "→ serving on port $PORT"
pkill -f "http.server $PORT" 2>/dev/null || true
setsid nohup python3 -m http.server $PORT --bind 0.0.0.0 \
  --directory "$APP/build/web" > /tmp/webserver.log 2>&1 < /dev/null & disown
sleep 1
curl -sf "http://localhost:$PORT" > /dev/null

echo "→ screenshotting tabs"
cd "$REPO"
node scripts/screenshot_tab.js $PORT

echo "→ screenshotting grammar"
node scripts/screenshot_grammar.js $PORT

echo "✓ done — screenshots in screenshots/"
