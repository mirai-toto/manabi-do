#!/usr/bin/env bash
# Builds the status-bar icon (ic_notification) from the launcher foreground:
# the white 学 becomes opaque white, the coloured background transparent, as
# Android's notification icons require. Run again if the launcher icon changes.
set -euo pipefail
RES="$(dirname "$0")/../../manabi_do/android/app/src/main/res"
SRC="$RES/drawable-xxxhdpi/ic_launcher_foreground.png"
declare -A SIZES=([mdpi]=24 [hdpi]=36 [xhdpi]=48 [xxhdpi]=72 [xxxhdpi]=96)

for density in "${!SIZES[@]}"; do
  size=${SIZES[$density]}
  glyph=$((size * 22 / 24)) # Android keeps a 1dp margin inside the 24dp box.
  # The glyph is white and the background is blue, so the red channel alone
  # tells them apart; it becomes the alpha of a plain white image.
  convert "$SRC" -alpha off -channel R -separate +channel -level 60%,95% -trim +repage \
    -resize "${glyph}x${glyph}" -background black -gravity center \
    -extent "${size}x${size}" -write mpr:alpha +delete \
    -size "${size}x${size}" xc:white mpr:alpha \
    -alpha off -compose CopyOpacity -composite \
    "$RES/drawable-$density/ic_notification.png"
done
echo "Wrote ic_notification.png for ${!SIZES[*]}"
