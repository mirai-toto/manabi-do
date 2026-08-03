#!/usr/bin/env bash
# Builds the Flutter web app and serves it on the given port.
# Usage: bash scripts/build_web.sh [port]
# Defaults to port 8767.
set -e

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
APP="$REPO/manabi_do"
PORT="${1:-8767}"

echo "→ building Flutter web"
cd "$APP"
flutter build web -t lib/main.dart --no-web-resources-cdn --debug 2>&1 | tail -3

echo "→ serving on port $PORT"
pkill -f "http.server $PORT" 2>/dev/null || true
setsid nohup python3 -m http.server "$PORT" --bind 0.0.0.0 \
  --directory "$APP/build/web" > /tmp/webserver.log 2>&1 < /dev/null & disown
sleep 1
curl -sf "http://localhost:$PORT" > /dev/null
echo "✓ serving at http://localhost:$PORT"
