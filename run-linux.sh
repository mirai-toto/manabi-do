#!/bin/bash
set -e

docker compose run --rm build
./manabi_do/build/linux/x64/release/bundle/manabi_do
