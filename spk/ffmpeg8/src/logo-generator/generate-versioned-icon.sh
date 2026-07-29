#!/bin/bash
# Generate a versioned FFmpeg package icon (transparent 256x256 PNG + editable SVG).
# Usage: ./generate-versioned-icon.sh <version> <out-basename>
#   ./generate-versioned-icon.sh 8.1 ffmpeg8   -> ffmpeg8.png + ffmpeg8.svg
# Logo: left graphic of the new FFmpeg logo. Version digits: Noto Sans Bold,
# white with a black outline, bottom-right. PNG rendered with ImageMagick using
# the bundled TTF; the SVG references "Noto Sans" for later editing.
set -e
VER="$1"; OUT="$2"
HERE="$(cd "$(dirname "$0")" && pwd)"
FONT="$HERE/NotoSans-Bold.ttf"
LOGO_HI="$HERE/logo-hi.png"

# --- PNG ---
convert -background none "$LOGO_HI" -resize 208x208 /tmp/_logo.png
convert -size 256x256 xc:none /tmp/_logo.png -gravity North -geometry +0+6 -composite /tmp/_base.png
convert -size 512x260 xc:none -font "$FONT" -pointsize 150 -gravity center \
  -stroke black -strokewidth 20 -fill white -annotate +0+0 "$VER" \
  -stroke none                 -fill white -annotate +0+0 "$VER" -trim +repage /tmp/_ver.png
convert /tmp/_ver.png -resize 122x /tmp/_ver_s.png
convert /tmp/_base.png /tmp/_ver_s.png -gravity SouthEast -geometry +14+22 -composite "${OUT}.png"

# --- SVG (editable vector source) ---
PATHS=$(perl -0777 -ne 'print $1 if /<svg[^>]*>(.*)<\/svg>/s' "$HERE/ffmpeg-logo-only.svg")
SCALE=3.382; TX=24; TY=6
cat > "${OUT}.svg" <<SVG
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256">
  <g transform="translate($TX,$TY) scale($SCALE)">
    $PATHS
  </g>
  <text x="242" y="236" text-anchor="end"
        font-family="Noto Sans, DejaVu Sans, sans-serif" font-weight="bold"
        font-size="82" fill="#ffffff" stroke="#000000" stroke-width="8"
        stroke-linejoin="round" paint-order="stroke">$VER</text>
</svg>
SVG
identify -format "%f: %wx%h alpha=%A\n" "${OUT}.png"
