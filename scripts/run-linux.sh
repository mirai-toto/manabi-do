#!/bin/bash
set -e

docker compose run --rm build
./manabi_do/build/linux/x64/release/bundle/manabi_do
sudo rm -rf manabi_do/build manabi_do/.dart_tool/build manabi_do/linux/flutter/ephemeral/.plugin_symlinks
