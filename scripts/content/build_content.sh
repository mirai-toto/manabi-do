#!/usr/bin/env bash
# Build the content database from source and put it in the app.
#
# This is the development counterpart to fetch_content.sh. Use it while you are
# changing the content pipeline, so you can see the result in the app without
# tagging a release for every iteration.
#
#   scripts/content/build_content.sh                 # build from committed content
#   scripts/content/build_content.sh --no-sentences  # skip the 20k sentence pass
#   scripts/content/build_content.sh --sync          # re-seed from upstream first
#
# It clones mirai-toto/manabi-content beside this repo if it is not already
# there, sets up a virtualenv, builds, and copies the result into
# manabi_do/assets/.
#
# Point it elsewhere with CONTENT_REPO=/path/to/manabi-content.
set -euo pipefail

REPO_URL="https://github.com/mirai-toto/manabi-content.git"
ASSET="manabi_do_content.db"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONTENT_REPO="${CONTENT_REPO:-$(dirname "$ROOT")/manabi-content}"
DEST="$ROOT/manabi_do/assets/$ASSET"

sync=0
passthrough=()
for arg in "$@"; do
  case "$arg" in
    --sync) sync=1 ;;
    --no-sentences) passthrough+=("--no-sentences") ;;
    *) echo "error: unknown option $arg" >&2; exit 1 ;;
  esac
done

if [ ! -d "$CONTENT_REPO/.git" ]; then
  echo "cloning $REPO_URL into $CONTENT_REPO"
  git clone --quiet "$REPO_URL" "$CONTENT_REPO" \
    || { echo "error: clone failed. The repo is private — is gh or git signed in?" >&2; exit 1; }
else
  echo "using $CONTENT_REPO ($(git -C "$CONTENT_REPO" rev-parse --short HEAD))"
fi

VENV="$CONTENT_REPO/.venv"
if [ ! -x "$VENV/bin/python" ]; then
  echo "creating the virtualenv"
  python3 -m venv "$VENV"
fi
"$VENV/bin/pip" install --quiet --upgrade pip
"$VENV/bin/pip" install --quiet -r "$CONTENT_REPO/requirements.txt"

# The schema lives in both repos. A mismatch builds a database the app refuses,
# so fail here rather than after the build.
"$VENV/bin/python" "$CONTENT_REPO/pipeline/check_schema.py" --app "$ROOT"

if [ "$sync" -eq 1 ]; then
  echo
  echo "re-seeding from upstream. This downloads about 320 MB on a cold cache."
  ( cd "$CONTENT_REPO" && "$VENV/bin/python" pipeline/sync_content.py )
fi

echo
( cd "$CONTENT_REPO" && "$VENV/bin/python" pipeline/generate.py "${passthrough[@]+"${passthrough[@]}"}" )

BUILT="$CONTENT_REPO/dist/$ASSET"
[ -f "$BUILT" ] || { echo "error: the build produced no $BUILT" >&2; exit 1; }

mkdir -p "$(dirname "$DEST")"
cp "$BUILT" "$DEST"

echo
echo "built content in place at manabi_do/assets/$ASSET"
echo "  source   $CONTENT_REPO ($(git -C "$CONTENT_REPO" rev-parse --short HEAD))"
echo "  sha256   $(sha256sum "$DEST" | cut -d' ' -f1)"
echo
echo "This is a local build, not a release. manabi_do/content.lock still pins"
echo "$(grep -E '^tag' "$ROOT/manabi_do/content.lock" | cut -d= -f2 | tr -d ' '), and CI will use that. Run scripts/content/fetch_content.sh to go back."
