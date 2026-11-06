#!/usr/bin/env bash
# Screenshots the home screen in every colour theme, light and dark, on the
# running emulator or device (debug build installed). Writes
# <out>/<palette>-<mode>.png and restores the theme that was set before.
set -euo pipefail
ADB="${ADB:-/mnt/c/Users/miout/AppData/Local/Android/Sdk/platform-tools/adb.exe}"
PKG=com.github.mirai_toto.manabi_do
OUT="${1:-theme_tour}"
PREFS=shared_prefs/FlutterSharedPreferences.xml
mkdir -p "$OUT"

set_pref() { # key value
  "$ADB" shell run-as "$PKG" sed -i "'/name=\"flutter.$1\"/d; s#</map>#    <string name=\"flutter.$1\">$2</string>\n</map>#'" "$PREFS"
}
get_pref() {
  "$ADB" shell run-as "$PKG" cat "$PREFS" | sed -n "s#.*name=\"flutter.$1\">\([^<]*\)<.*#\1#p"
}

old_palette="$(get_pref theme_palette)"
old_mode="$(get_pref theme_mode)"

for palette in fuji ai sakura matcha kuri sumi; do
  for mode in light dark; do
    "$ADB" shell am force-stop "$PKG"
    set_pref theme_palette "$palette"
    set_pref theme_mode "$mode"
    "$ADB" shell monkey -p "$PKG" 1 >/dev/null 2>&1
    sleep 7
    "$ADB" exec-out screencap -p >"$OUT/$palette-$mode.png"
    echo "$OUT/$palette-$mode.png"
  done
done

"$ADB" shell am force-stop "$PKG"
set_pref theme_palette "${old_palette:-fuji}"
set_pref theme_mode "${old_mode:-system}"
