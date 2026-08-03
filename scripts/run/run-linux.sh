#!/bin/bash
set -e

ROOT="$(dirname "$(realpath "$0")")/../.."

docker compose -f "$ROOT/docker-compose.yml" run --rm build
"$ROOT/manabi_do/build/linux/x64/release/bundle/manabi_do"
sudo rm -rf "$ROOT/manabi_do/build" "$ROOT/manabi_do/.dart_tool/build" "$ROOT/manabi_do/linux/flutter/ephemeral/.plugin_symlinks" "$ROOT/manabi_do/windows/flutter/ephemeral/.plugin_symlinks"
