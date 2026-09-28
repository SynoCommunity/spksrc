---
title: GStreamer
description: GStreamer pipeline-based multimedia framework
tags:
  - media
  - transcoding
  - video
  - audio
---

# GStreamer

!!! note "Package Information"
    - **Maintainer**: @th0ma7
    - **Upstream**: [gstreamer.freedesktop.org](https://gstreamer.freedesktop.org/)
    - **License**: LGPLv2.1 (GPL plugins enabled)

GStreamer is a library for constructing graphs of media-handling components.
This package provides the GStreamer core along with the `base`, `good`, `bad`
and `ugly` plugin sets and the RTSP server library, for use from the command
line or by other packages.

Commands are located in `/var/packages/gstreamer/target/bin` and linked into
`/usr/local/bin`:

- `gst-launch-1.0` - build and run a pipeline
- `gst-inspect-1.0` - list plugins and elements, show element details
- `gst-discoverer-1.0` - show media file information
- `gst-play-1.0` - play back media files
- `gst-typefind-1.0` - detect media types

## Usage

```bash
# List available plugins and elements
gst-inspect-1.0

# Show details for a given element
gst-inspect-1.0 x264enc

# Inspect a media file
gst-discoverer-1.0 /volume1/video/movie.mkv

# Transcode a file to H.264/AAC in MP4
gst-launch-1.0 filesrc location=input.mkv ! decodebin name=d \
    d. ! queue ! videoconvert ! x264enc ! h264parse ! mp4mux name=m ! filesink location=output.mp4 \
    d. ! queue ! audioconvert ! fdkaacenc ! m.
```

### VideoStation seek options

`gst-launch-1.0` carries the Synology VideoStation extensions allowing a pipeline
to start at a given position:

- `-s`, `--seek=TIME` - flushing seek to TIME (seconds) once the pipeline is prerolled
- `-S`, `--seek-no-flush=TIME` - same, without flushing

## Hardware Acceleration

On Intel-based models, VA-API accelerated elements (`vah264dec`, `vah265dec`,
`vah264enc`, `vapostproc`, ...) are provided by the `va` plugin, using the
drivers from the [SynoCli Video Driver](synocli-videodriver.md) package
which is installed as a dependency.

```bash
gst-inspect-1.0 va
```

To access the GPU, your user must be a member of the `videodriver` group,
see [FFmpeg: User Permissions](ffmpeg.md#user-permissions) for details.

!!! note
    The legacy `gstreamer-vaapi` plugins (`vaapih264dec`, ...) were removed upstream
    in GStreamer 1.28 in favor of the `va` plugin. The OpenMAX wrapper (`gst-omx`),
    discontinued upstream after 1.22, is not provided.

## Troubleshooting

### Plugin not found

GStreamer caches its plugin registry in `~/.cache/gstreamer-1.0/`. After a
package upgrade, remove the cache so plugins are rescanned:

```bash
rm -rf ~/.cache/gstreamer-1.0
gst-inspect-1.0 > /dev/null
```

Use `GST_DEBUG` to get more information on a failing pipeline:

```bash
GST_DEBUG=3 gst-launch-1.0 ...
```

## Architecture Support

| Architecture | DSM 6 | DSM 7 | Notes |
|-------------|-------|-------|---------|
| x64 | ✓ | ✓ | VA-API hardware acceleration |
| aarch64 | ✓ | ✓ | |
| armv7 | ✓ | ✓ | |
| i686 | ✓ | ✓ | |
| ppc (qoriq) | ✓ | - | No `openh264` |
| armv5, hi3535 | - | - | Compiler too old (gcc < 4.9) |

## See Also

- [FFmpeg](ffmpeg.md)
- [SynoCli Video Driver](synocli-videodriver.md)
- [GStreamer documentation](https://gstreamer.freedesktop.org/documentation/)
