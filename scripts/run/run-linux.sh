#!/bin/bash
set -e

ROOT="$(dirname "$(realpath "$0")")/../.."
COMPOSE="docker compose -f $ROOT/docker-compose.yml"

# The app support dir a release build uses on Linux. The bundled asset is only
# copied over it when _assetDbVersion changes, so a rebuilt DB with an unchanged
# version would otherwise be ignored.
RUNTIME_DB="$HOME/.local/share/com.manabisho.manabi_do"

# 1. Rebuild the content DB in the container, from its own downloaded sources.
#    Pass --skip-content to reuse the committed asset instead.
if [ "$1" != "--skip-content" ]; then
  $COMPOSE run --rm content
fi

# 2. Compile.
$COMPOSE run --rm build

# 3. Drop the previous runtime copy so the freshly built asset is the one used.
rm -rf "$RUNTIME_DB/manabi_do.db" \
       "$RUNTIME_DB/manabi_do.db-wal" \
       "$RUNTIME_DB/manabi_do.db-shm" \
       "$RUNTIME_DB/manabi_do.db.version"

"$ROOT/manabi_do/build/linux/x64/release/bundle/manabi_do"

sudo rm -rf "$ROOT/manabi_do/build" \
            "$ROOT/manabi_do/.dart_tool/build" \
            "$ROOT/manabi_do/linux/flutter/ephemeral/.plugin_symlinks" \
            "$ROOT/manabi_do/windows/flutter/ephemeral/.plugin_symlinks"
