#!/bin/bash
set -e

# Builds and runs the app entirely inside Docker, against a content DB the
# container rebuilds from its own downloaded sources. The host contributes the
# source tree and an X server; everything else — the content sources, the build
# output, the runtime database — lives in container volumes.

ROOT="$(dirname "$(realpath "$0")")/../.."
COMPOSE="docker compose -f $ROOT/docker-compose.yml"

$COMPOSE run --rm content
$COMPOSE run --rm build

# The app needs to reach the host's X server to draw a window.
trap 'xhost -local:docker >/dev/null 2>&1 || true' EXIT
xhost +local:docker >/dev/null 2>&1 || true

$COMPOSE run --rm app
