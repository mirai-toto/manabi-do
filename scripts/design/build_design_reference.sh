#!/usr/bin/env bash
# Builds the full design reference: the widgetbook web bundle plus the generated
# token page that embeds it.
#
#   bash scripts/design/build_design_reference.sh [--debug] [--serve]
#
# Output is design-reference/ at the repo root (gitignored):
#   index.html      the token reference, with live widget previews
#   widgetbook/     the widgetbook web build the previews point at
#
# Release is the default because the debug bundle is ~100 MB against ~90 MB.
# Pass --debug while iterating: release swallows widget-build exceptions and
# paints the crashed subtree as a silent grey rectangle.
#
# The page has to be served over HTTP. Opened from disk, file:// renders each
# preview iframe as a directory listing, and Flutter cannot boot from it at all.
set -euo pipefail

source "$(dirname "$0")/../common/env.sh"
source "$SCRIPTS/common/flutter_web.sh"
source "$SCRIPTS/common/serve.sh"

MODE="--release"
SERVE=0
for arg in "$@"; do
  case "$arg" in
    --debug) MODE="--debug" ;;
    --serve) SERVE=1 ;;
    *) echo "unknown option: $arg" >&2; exit 1 ;;
  esac
done

OUT="$REPO/design-reference"

flutter_web_build lib/widgetbook.dart "$MODE"

echo "→ staging into design-reference/widgetbook"
mkdir -p "$OUT"
rm -rf "$OUT/widgetbook"
cp -r "$APP/build/web" "$OUT/widgetbook"

# Flutter hardcodes an absolute base href. A relative one lets the bundle be
# served from any sub-path, which is what a Pages deploy needs.
sed -i 's|<base href="/">|<base href="./">|' "$OUT/widgetbook/index.html"

echo "→ generating the reference page"
# Run from the app directory: the generator reads lib/ with relative paths.
(cd "$APP" && dart run "$SCRIPTS/design/gen_design_reference.dart")

du -sh "$OUT/widgetbook" | sed 's/^/  widgetbook bundle: /'

if [ "$SERVE" -eq 1 ]; then
  serve_dir "$REPO" 8800
  echo "  open http://localhost:8800/design-reference/"
else
  echo
  echo "Serve the repo root, then open /design-reference/:"
  echo "  bash scripts/design/build_design_reference.sh --serve"
fi
