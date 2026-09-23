#!/usr/bin/env bash
# Builds a Flutter web target into manabi_do/build/web.
#
#   source "$(dirname "$0")/../common/flutter_web.sh"
#   flutter_web_build lib/main.dart --debug
#
# `--no-web-resources-cdn` is not optional: without it Flutter fetches CanvasKit
# from gstatic.com, which fails behind a restricted proxy and leaves the app
# hanging on a blank canvas with no error.
#
# `--no-wasm-dry-run` only silences advice about a build mode we do not use.

flutter_web_build() {
  local target="${1:?target required, e.g. lib/main.dart}"
  local mode="${2:---release}"

  echo "→ building $target ($mode)"
  (
    cd "$APP"
    flutter build web -t "$target" \
      --no-web-resources-cdn \
      --no-wasm-dry-run \
      "$mode"
  )
}
