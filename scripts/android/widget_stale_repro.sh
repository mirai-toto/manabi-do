#!/usr/bin/env bash
# Reinstalls the debug APK with the widget data wiped, then launches the app
# while the widgets' Glance sessions are still open, and screenshots the home
# screen. Widgets that stay blank did not redraw on an in-session update.
set -euo pipefail
ADB="${ADB:-/mnt/c/Users/miout/AppData/Local/Android/Sdk/platform-tools/adb.exe}"
PKG=com.github.mirai_toto.manabi_do
OUT="${1:-widget_repro.png}"
APK="$(dirname "$0")/../../manabi_do/build/app/outputs/flutter-apk/app-debug.apk"

"$ADB" shell am force-stop "$PKG"
"$ADB" shell run-as "$PKG" rm -f shared_prefs/HomeWidgetPreferences.xml
"$ADB" install -r "$APK" >/dev/null
sleep 3
"$ADB" shell monkey -p "$PKG" 1 >/dev/null 2>&1
sleep 12
"$ADB" shell input keyevent KEYCODE_HOME
sleep 3
"$ADB" exec-out screencap -p >"$OUT"
echo "$OUT"
