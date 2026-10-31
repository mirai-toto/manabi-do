#!/usr/bin/env bash
# Fetch the content database this app is pinned to.
#
# The database is built in the mirai-toto/manabi-content repo and published as
# a release asset. This app does not track it: one 22 MB build artifact per
# rebuild made 70% of the git history generated output.
#
# The pin lives in manabi_do/content.lock. Changing that file is the whole
# upgrade.
#
#   scripts/content/fetch_content.sh              # fetch what the lock says
#   scripts/content/fetch_content.sh --update-lock  # record the hash after a fetch
#
# Needs the gh CLI, signed in. The content repo is private, so CI passes a
# read-only token as GH_TOKEN — secrets.CONTENT_PAT.
set -euo pipefail

REPO="mirai-toto/manabi-content"
ASSET="manabi_do_content.db"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LOCK="$ROOT/manabi_do/content.lock"
DEST="$ROOT/manabi_do/assets/$ASSET"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/manabi-content"

update_lock=0
[ "${1:-}" = "--update-lock" ] && update_lock=1

if [ ! -f "$LOCK" ]; then
  echo "error: no pin file at $LOCK" >&2
  exit 1
fi

read_key() { grep -E "^$1[[:space:]]*=" "$LOCK" | head -1 | cut -d= -f2- | tr -d '[:space:]'; }
TAG="$(read_key tag)"
WANT_SHA="$(read_key sha256)"

if [ -z "$TAG" ]; then
  echo "error: $LOCK does not name a tag" >&2
  exit 1
fi

sha_of() { sha256sum "$1" | cut -d' ' -f1; }

mkdir -p "$CACHE" "$(dirname "$DEST")"
CACHED="$CACHE/$TAG-$ASSET"

if [ -f "$CACHED" ] && [ -n "$WANT_SHA" ] && [ "$(sha_of "$CACHED")" = "$WANT_SHA" ]; then
  echo "content $TAG already cached"
else
  echo "downloading content $TAG from $REPO"
  rm -f "$CACHED"
  gh release download "$TAG" --repo "$REPO" --pattern "$ASSET" --output "$CACHED" \
    || { echo "error: could not download $TAG. Is the tag published, and is gh signed in?" >&2; exit 1; }
fi

GOT_SHA="$(sha_of "$CACHED")"

if [ -n "$WANT_SHA" ]; then
  if [ "$GOT_SHA" != "$WANT_SHA" ]; then
    echo "error: checksum mismatch for $TAG" >&2
    echo "  expected $WANT_SHA" >&2
    echo "  got      $GOT_SHA" >&2
    echo "The release asset changed after it was pinned. Do not use it." >&2
    rm -f "$CACHED"
    exit 1
  fi
elif [ "$update_lock" -eq 1 ]; then
  tmp="$(mktemp)"
  sed -E "s|^sha256[[:space:]]*=.*|sha256 = $GOT_SHA|" "$LOCK" > "$tmp"
  mv "$tmp" "$LOCK"
  echo "recorded sha256 = $GOT_SHA in content.lock"
else
  echo "warning: $LOCK pins no checksum. Re-run with --update-lock to record it." >&2
fi

cp "$CACHED" "$DEST"

# Verify what we leave behind, not just the cache. A truncated or partly
# written asset otherwise surfaces much later as "no such table", with
# nothing pointing back at this step.
DEST_SHA="$(sha_of "$DEST")"
if [ "$DEST_SHA" != "$GOT_SHA" ]; then
  echo "error: $DEST does not match the file that was copied into it" >&2
  echo "  cache $GOT_SHA" >&2
  echo "  dest  $DEST_SHA" >&2
  exit 1
fi

echo "content $TAG in place at manabi_do/assets/$ASSET"
