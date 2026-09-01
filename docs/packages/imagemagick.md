---
title: ImageMagick
description: Image manipulation and conversion toolkit
tags:
  - image
  - graphics
  - tools
---

# ImageMagick

ImageMagick is a software suite to create, edit, compose, or convert bitmap images. It reads and writes over 200 image formats and provides a command-line toolkit for image processing.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | imagemagick |
| Upstream | [imagemagick.org](https://imagemagick.org/) |
| License | [ImageMagick License](https://imagemagick.org/script/license.php) |

## DSM's Built-in ImageMagick

DSM ships with an older ImageMagick 6.x pre-installed. Its `compare`, `composite`, `convert`, `identify`, and `montage` commands take priority in the PATH, so running those names executes the DSM version instead of this package's ImageMagick 7 tools.

To use this package's ImageMagick tools:

- Run `magick` with the legacy name as a subcommand, e.g. `magick convert`, `magick identify`, or `magick montage`.
- Or invoke the full path, e.g. `/var/packages/imagemagick/target/bin/convert`.

## Included Tools

### ImageMagick tools

| Tool | Description |
|------|-------------|
| `magick` | The main ImageMagick 7 command |
| `mogrify` | Resize, blur, crop, and otherwise modify images in place |
| `convert` | Convert between image formats (deprecated wrapper) |
| `identify` | Describe image format and characteristics |
| `montage` | Create a composite image from several images |
| `compare` | Mathematically compare images |
| `composite` | Overlay one image on another |

### Additional image compression tools

These tools are not part of ImageMagick and are bundled separately with this package.

| Tool | Description |
|------|-------------|
| `jpegoptim` | Optimize/compress JPEG files |
| `optipng` | PNG optimizer that recompresses without losing information |
| `pngcrush` | Optimize PNG files |
| `pngquant` | Lossy compression of PNG images |

## Usage Examples

### Convert an image

```bash
magick input.png output.jpg
```

### Resize an image

```bash
magick input.jpg -resize 800x600 output.jpg
```

### Get image information

```bash
magick identify input.jpg
```

### Optimize a JPEG

```bash
jpegoptim --strip-all photo.jpg
```

### Optimize a PNG (lossless)

```bash
optipng -o7 photo.png
```

### Compress a PNG (lossy)

```bash
pngquant --quality=65-80 photo.png
```

## Data Locations

- Configuration: none (command-line tools)
- Executables: `/var/packages/imagemagick/target/bin/`
