#!/bin/bash
set -e

# Builds and runs the app entirely inside Docker. The host contributes the
# source tree, the content database and an X server; the build output and the
# runtime database live in container volumes.
#
# The content database is not in the repo. It is fetched from the pinned
# release in mirai-toto/manabi-content, on the host, because that is where the
# gh CLI is signed in.

ROOT="$(dirname "$(realpath "$0")")/../.."
COMPOSE="docker compose -f $ROOT/docker-compose.yml"

"$ROOT/scripts/content/fetch_content.sh"
$COMPOSE run --rm build

# The app needs to reach the host's X server to draw a window.
trap 'xhost -local:docker >/dev/null 2>&1 || true' EXIT
xhost +local:docker >/dev/null 2>&1 || true

$COMPOSE run --rm app
