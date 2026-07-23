# FFmpeg versioned package icons

Sources to regenerate the spk/ffmpeg{4,5,6,7,8}/src/ffmpeg.png icons.

- FFmpeg_Logo_new-original.svg : full new FFmpeg logo (logo + "FFmpeg" text),
  from https://en.wikipedia.org/wiki/File:FFmpeg_Logo_new.svg
- ffmpeg-logo-only.svg : left graphic only (text group cropped out),
  viewBox 0 0 61.5 60.19
- generate-versioned-icon.sh : builds a 256x256 transparent PNG with the
  version digits (outlined) bottom-right. Usage:
    ./generate-versioned-icon.sh 8.1 ffmpeg.png

Note: needs an SVG renderer. No system rsvg/cairo here, so the logo was
rendered once with cairosvg + the x64 libcairo from the synocli-videodriver
staging into logo-hi.png (also kept here). To fully regenerate from SVG,
render ffmpeg-logo-only.svg to logo-hi.png (1024x1024) first.
