#!/bin/bash
set -e

# Builds and runs the app entirely inside Docker, against a content DB the
# container builds from its own downloaded sources. Nothing on the host is read
# or written except the repo itself: the runtime database lives in the
# `app-data` volume, so the host's ~/.local/share is left alone.
#
#   ./run-linux.sh                    full run, content DB rebuilt from scratch
#   ./run-linux.sh --skip-content     reuse the committed asset (faster)

ROOT="$(dirname "$(realpath "$0")")/../.."
COMPOSE="docker compose -f $ROOT/docker-compose.yml"

if [ "$1" != "--skip-content" ]; then
  $COMPOSE run --rm content
fi

$COMPOSE run --rm build

# The app needs to reach the host's X server to draw a window.
xhost +local:docker >/dev/null 2>&1 || true
$COMPOSE run --rm app
xhost -local:docker >/dev/null 2>&1 || true

sudo rm -rf "$ROOT/manabi_do/build" \
            "$ROOT/manabi_do/.dart_tool/build" \
            "$ROOT/manabi_do/linux/flutter/ephemeral/.plugin_symlinks" \
            "$ROOT/manabi_do/windows/flutter/ephemeral/.plugin_symlinks"
