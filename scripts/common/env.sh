#!/usr/bin/env bash
# Shared paths. Source this, do not execute it:
#
#   source "$(dirname "$0")/../common/env.sh"
#
# Every script used to re-derive the repo root with its own `cd ../..` dance,
# which silently broke whenever a script moved between directories.

# Resolve from this file's own location, so a caller can live at any depth.
_COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REPO="$(cd "$_COMMON_DIR/../.." && pwd)"
APP="$REPO/manabi_do"
SCRIPTS="$REPO/scripts"

export REPO APP SCRIPTS
