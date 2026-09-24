#!/usr/bin/env bash
# Builds and serves the design reference. See --help.
set -euo pipefail

source "$(dirname "$0")/../common/env.sh"
source "$SCRIPTS/common/flutter_web.sh"
source "$SCRIPTS/common/serve.sh"

OUT="$REPO/design-reference"
BUNDLE="$OUT/widgetbook"
USE_CASES="$APP/lib/widgetbook.directories.g.dart"

MODE="--release"
PORT=8800
REBUILD=0
SERVE=1

usage() {
  cat <<'EOF'
Builds and serves the design reference: colour tokens with WCAG contrast
grades, the dimension and type scales, and a live preview of every widget.

  bash scripts/design/build_design_reference.sh [options]

Options
  -r, --rebuild     Rebuild the widgetbook bundle. Takes about 90 seconds, and
                    is only needed when a widget or use case changed. Happens
                    automatically when the bundle is missing.
  -p, --port N      Port to serve on. Default 8800.
  -n, --no-serve    Build only, do not serve.
  -d, --debug       Debug widgetbook build. Slower and much larger, but a
                    release build paints crashed widgets as silent grey boxes,
                    so use this when a preview looks wrong.
  -h, --help        This message.

Typical use
  ...build_design_reference.sh              changed a colour or dimension — about a second
  ...build_design_reference.sh --rebuild    changed a widget or added a use case
  ...build_design_reference.sh --no-serve   just refresh the files

The page must be served over HTTP: opened from disk, every preview turns into a
directory listing and Flutter cannot start at all. That is why serving is the
default rather than an opt-in.
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    -r|--rebuild)  REBUILD=1 ;;
    -d|--debug)    MODE="--debug"; REBUILD=1 ;;
    -n|--no-serve) SERVE=0 ;;
    -p|--port)     PORT="${2:?--port needs a number}"; shift ;;
    -h|--help)     usage; exit 0 ;;
    *) echo "unknown option: $1" >&2; echo "try --help" >&2; exit 1 ;;
  esac
  shift
done

# The widgetbook bundle is the slow half and rarely changes, so it is only
# rebuilt on request or when it is missing. Regenerating the page itself is
# under a second, so that always runs.
if [ ! -d "$BUNDLE" ]; then
  echo "→ no widgetbook bundle yet, building it once"
  REBUILD=1
fi

if [ "$REBUILD" -eq 1 ]; then
  flutter_web_build lib/widgetbook.dart "$MODE"
  echo "→ staging the bundle"
  rm -rf "$BUNDLE"
  mkdir -p "$OUT"
  cp -r "$APP/build/web" "$BUNDLE"
  # Flutter hardcodes an absolute base href. A relative one lets the bundle be
  # served from any sub-path, which a Pages deploy needs.
  sed -i 's|<base href="/">|<base href="./">|' "$BUNDLE/index.html"
elif [ "$USE_CASES" -nt "$BUNDLE" ]; then
  echo "! use cases changed since the bundle was built — previews may be stale."
  echo "  rerun with --rebuild to pick them up."
fi

# Reads lib/ by relative path, so it has to run from the app directory.
(cd "$APP" && dart run "$SCRIPTS/design/gen_design_reference.dart")

if [ "$SERVE" -eq 0 ]; then
  echo "✓ written to design-reference/ — serve the repo root to view it"
  exit 0
fi

if curl -sf -o /dev/null "http://localhost:$PORT/design-reference/"; then
  echo "✓ already served"
else
  serve_dir "$REPO" "$PORT" >/dev/null
fi

echo
echo "  http://localhost:$PORT/design-reference/"
