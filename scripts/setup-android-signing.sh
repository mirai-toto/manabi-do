#!/usr/bin/env bash
# setup-android-signing.sh — One-time Android release signing setup for Manabi Do.
#
# This script is meant to be run once by the app maintainer on their local machine.
# It should NOT be run by open-source contributors — they don't need it.
#
# What it does:
#   1. Generates a strong random password and saves it to Bitwarden via rbw
#   2. Creates a release keystore at ~/.manabi-do-release.jks (outside the repo)
#   3. Writes manabi_do/android/key.properties (gitignored — never committed)
#   4. Patches manabi_do/android/app/build.gradle.kts to use release signing
#      when key.properties is present, and fall back to debug signing otherwise
#
# Requirements:
#   - rbw (https://github.com/doy/rbw) installed and unlocked
#   - Java keytool on PATH (comes with any JDK)
#
# Usage:
#   bash scripts/setup-android-signing.sh
#
# After running:
#   - Back up ~/.manabi-do-release.jks somewhere safe (e.g. Bitwarden file attachment)
#   - The password is retrievable at any time with: rbw get "Manabi Do Keystore"
#   - Build a signed release bundle with: flutter build appbundle --release
#
# WARNING: Never delete or lose the keystore — Google Play ties your app identity
# to it. You cannot update your app on the Play Store with a different key.
set -euo pipefail

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  awk '/^#!/{next} /^#/{sub(/^# ?/,""); print; next} {exit}' "$0"
  exit 0
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KEYSTORE_PATH="$HOME/.manabi-do-release.jks"
KEY_PROPS="$REPO_ROOT/manabi_do/android/key.properties"
BUILD_GRADLE="$REPO_ROOT/manabi_do/android/app/build.gradle.kts"

# ── Preflight ──────────────────────────────────────────────────────────────────

if ! command -v rbw &>/dev/null; then
  echo "Error: rbw not found. Install it from https://github.com/doy/rbw" >&2
  exit 1
fi

if ! rbw unlocked &>/dev/null; then
  echo "Bitwarden is locked. Run: rbw unlock" >&2
  exit 1
fi

if [[ -f "$KEYSTORE_PATH" ]]; then
  echo "Error: keystore already exists at $KEYSTORE_PATH" >&2
  echo "Delete it first if you want to regenerate." >&2
  exit 1
fi

# ── Generate password and save to Bitwarden ────────────────────────────────────

echo "Generating password and saving to Bitwarden..."
KS_PASS=$(rbw generate 32 "Manabi Do Keystore" "manabido" --no-symbols)

# ── Create keystore ────────────────────────────────────────────────────────────

echo "Creating keystore at $KEYSTORE_PATH..."
keytool -genkey -v \
  -keystore "$KEYSTORE_PATH" \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias manabido \
  -dname "CN=mirai-toto, O=ManabiDo, C=FR" \
  -storepass "$KS_PASS" \
  -keypass "$KS_PASS"

# ── Write key.properties ───────────────────────────────────────────────────────

echo "Writing $KEY_PROPS..."
cat > "$KEY_PROPS" <<EOF
storePassword=$KS_PASS
keyPassword=$KS_PASS
keyAlias=manabido
storeFile=$KEYSTORE_PATH
EOF

# ── Patch build.gradle.kts ────────────────────────────────────────────────────

echo "Patching $BUILD_GRADLE..."
cp "$(dirname "$0")/app.build.gradle.kts" "$BUILD_GRADLE"

# ── Clear the variable ─────────────────────────────────────────────────────────
unset KS_PASS

echo ""
echo "Done!"
echo "  Keystore : $KEYSTORE_PATH"
echo "  Props    : $KEY_PROPS"
echo ""
echo "IMPORTANT: Back up $KEYSTORE_PATH somewhere safe (e.g. Bitwarden file attachment)."
echo "You cannot change this key after uploading your first release to the Play Store."
