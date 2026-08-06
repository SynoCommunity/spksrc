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
| Default Port | None (CLI tools) |

## Included Tools

| Tool | Description |
|------|-------------|
| `magick` | The main ImageMagick 7 command |
| `convert` | Convert between image formats (deprecated wrapper) |
| `identify` | Describe image format and characteristics |
| `mogrify` | Resize, blur, crop, and otherwise modify images in place |
| `montage` | Create a composite image from several images |
| `compare` | Mathematically compare images |
| `composite` | Overlay one image on another |
| `jpegoptim` | Optimize/compress JPEG files |
| `optipng` | PNG optimizer that recompresses without losing information |
| `pngcrush` | Optimize PNG files |
| `pngquant` | Lossy compression of PNG images |

## Features

- Support for 200+ image formats (including RAW, OpenEXR, SVG, JPEG XL, UHDR/HEIC)
- Built-in fonts and text rendering
- Image resizing, cropping, rotating, and filtering
- Color management (ICC profiles)
- Batch processing via the command line

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
identify input.jpg
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

## Related Packages

- [SynoCli File Tools](synocli-file.md) - File utilities
