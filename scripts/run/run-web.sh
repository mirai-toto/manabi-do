#!/usr/bin/env bash
# Builds the Flutter web app and serves it.
# Usage: bash scripts/run/run-web.sh [port]   (defaults to 8767)
set -euo pipefail

source "$(dirname "$0")/../common/env.sh"
source "$SCRIPTS/common/flutter_web.sh"
source "$SCRIPTS/common/serve.sh"

PORT="${1:-8767}"

flutter_web_build lib/main.dart --debug
serve_dir "$APP/build/web" "$PORT" 0.0.0.0
