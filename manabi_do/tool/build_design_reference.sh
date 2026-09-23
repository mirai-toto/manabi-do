#!/usr/bin/env bash
# Builds the full design reference: the widgetbook web bundle plus the generated
# token page that embeds it.
#
#   tool/build_design_reference.sh [--debug]
#
# Output is ../design-reference/ (gitignored):
#   index.html      the token reference, with live widget previews
#   widgetbook/     the widgetbook web build the previews point at
#
# Release is the default because the debug bundle is ~100 MB against ~20 MB.
# Pass --debug while iterating: release swallows widget-build exceptions and
# paints the crashed subtree as a silent grey rectangle.
set -euo pipefail

cd "$(dirname "$0")/.."
MODE="--release"
[[ "${1:-}" == "--debug" ]] && MODE="--debug"

OUT="../design-reference"

echo "▶ building widgetbook ($MODE)"
flutter build web -t lib/widgetbook.dart --no-web-resources-cdn --no-wasm-dry-run "$MODE"

echo "▶ staging into $OUT/widgetbook"
mkdir -p "$OUT"
rm -rf "$OUT/widgetbook"
cp -r build/web "$OUT/widgetbook"

# Flutter hardcodes an absolute base href. A relative one lets the bundle be
# served from any sub-path, which is what a Pages deploy needs.
sed -i 's|<base href="/">|<base href="./">|' "$OUT/widgetbook/index.html"

echo "▶ generating the reference page"
dart run tool/gen_design_reference.dart

echo
echo "Done. Serve the repo root and open /design-reference/:"
echo "  python3 -m http.server 8800 --directory ."
du -sh "$OUT/widgetbook" | sed 's/^/  widgetbook bundle: /'
