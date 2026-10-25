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

GStreamer is a library for constructing graphs of media-handling components.
This package provides the GStreamer core along with the `base`, `good`, `bad`
and `ugly` plugin sets, the `libav` plugin and the RTSP server library, for use
from the command line or by other packages.

Commands are located in `/var/packages/gstreamer/target/bin` and linked into
`/usr/local/bin`:

- `gst-launch-1.0` - build and run a pipeline
- `gst-inspect-1.0` - list plugins and elements, show element details
- `gst-discoverer-1.0` - show media file information
- `gst-play-1.0` - play back media files
- `gst-typefind-1.0` - detect media types

```bash
ls -l /usr/local/bin/gst-*
# gst-launch-1.0 -> /var/packages/gstreamer/target/bin/gst-launch-1.0
# ...
```

!!! note
    A non-interactive `ssh` command does not have `/usr/local/bin` in its `PATH`
    on DSM. Use the full path, or `export PATH=/usr/local/bin:$PATH` first.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | gstreamer |
| Maintainer | @th0ma7 |
| Upstream | [gstreamer.freedesktop.org](https://gstreamer.freedesktop.org/) |
| License | LGPLv2.1 (GPL plugins enabled) |
| Dependencies | [FFmpeg 8](ffmpeg.md) (`libav` plugin), [SynoCli Video Driver](synocli-videodriver.md) (x64, `va` plugin) |

The `libav` plugin uses the libraries of the FFmpeg 8 package, which is installed
alongside. Both must come from the same build: if `gst-inspect-1.0 -b` lists a
blacklisted plugin, update FFmpeg 8 (see [Troubleshooting](#troubleshooting)).

## Plugins

On x64 with DSM 7, `gst-inspect-1.0` reports 199 plugins and about 1250 elements.

| Purpose | Elements |
|---------|----------|
| Video decoding | `avdec_*` (FFmpeg: MPEG-2, MPEG-4, VC-1, ...), `openh264dec`, `libde265dec`, `av1dec` (aom), `vp8dec`/`vp9dec` |
| Video encoding | `x264enc`, `x265enc`, `openh264enc`, `av1enc` (aom), `svtav1enc` (64-bit), `vp8enc`/`vp9enc`, `avenc_*` |
| Audio | `fdkaacenc`/`fdkaacdec`, `lamemp3enc`, `mpg123audiodec`, `flacenc`/`flacdec`, `opusenc`/`opusdec`, `vorbisenc`/`vorbisdec`, `avdec_ac3`, `avdec_dca`, ... |
| Containers | `qtdemux`/`mp4mux`, `matroskademux`/`matroskamux`, `tsdemux`/`mpegtsmux`, ... |
| Streaming | `hlsdemux`, `hlssink2`, `dashdemux`, `srtsrc`/`srtsink`, `rtspsrc`, `rtspclientsink` |
| Capture | `v4l2src`, `dvbsrc` |
| Hardware (x64) | `vah264dec`, `vah265dec`, `vampeg2dec`, `vah264enc`, `vah265enc`, `vapostproc`, ... (see [Hardware Acceleration](#hardware-acceleration)) |

```bash
# All plugins and elements
gst-inspect-1.0

# Details of one element (properties, supported formats)
gst-inspect-1.0 x264enc
```

## Usage

```bash
# Inspect a media file
gst-discoverer-1.0 /volume1/video/movie.mkv

# Transcode any input to H.264/AAC in MP4 on the CPU
gst-launch-1.0 -e filesrc location=input.mkv ! decodebin name=d \
    d. ! queue ! videoconvert ! x264enc speed-preset=veryfast bitrate=4000 ! h264parse ! mp4mux name=m ! filesink location=output.mp4 \
    d. ! queue ! audioconvert ! audioresample ! fdkaacenc ! m.
```

`decodebin` picks the decoder for each stream: the hardware one when it can
use it, otherwise the software one. TV recordings in MPEG-2 video and AC-3
audio are decoded by `vampeg2dec` (or `avdec_mpeg2video`) and `avdec_ac3`.

### VideoStation seek options

`gst-launch-1.0` carries the Synology VideoStation extensions that start a
pipeline at a given position, once it is prerolled:

- `-s`, `--seek=TIME` - flushing seek to TIME (seconds)
- `-S`, `--seek-no-flush=TIME` - same, without flushing

```bash
# Play from 15 s
gst-launch-1.0 -s 15 filesrc location=input.mp4 ! decodebin ! fakesink sync=true
```

## User Permissions

To use the GPU, your user must be a member of the `videodriver` group. Without
it, the `va` plugin loads but exposes no element, and `decodebin` falls back to
software decoding.

```bash
sudo synogroup --memberadd videodriver $(whoami)
# Log out and back in, then check:
id
# uid=1030(<username>) gid=100(users) groups=100(users),101(administrators),937(videodriver)
```

See [FFmpeg: User Permissions](ffmpeg.md#user-permissions) for details.

## Hardware Acceleration

On Intel-based models, VA-API accelerated elements are provided by the `va`
plugin, using the drivers from the [SynoCli Video Driver](synocli-videodriver.md)
package, installed as a dependency.

### Validate the VA-API elements

```bash
gst-inspect-1.0 va
# Output on an Intel Celeron J3455 (Gen9, DS918+):
#   vah264dec: VA-API H.264 Decoder in Intel(R) Gen Graphics
#   vah264enc: VA-API H.264 Encoder in Intel(R) Gen Graphics
#   vah265dec: VA-API H.265 Decoder in Intel(R) Gen Graphics
#   vah265enc: VA-API H.265 Encoder in Intel(R) Gen Graphics
#   vampeg2dec: VA-API Mpeg2 Decoder in Intel(R) Gen Graphics
#   vapostproc: VA-API Video Postprocessor in Intel(R) Gen Graphics
#   vadeinterlace, vacompositor, vajpegdec/enc, vavp8dec/enc, vavp9dec, ...
```

The list depends on the GPU. An empty list means the user cannot access the GPU
(see [User Permissions](#user-permissions)); `vainfo` from the video driver
package shows what the driver itself supports (see
[FFmpeg: Hardware Acceleration](ffmpeg.md#hardware-acceleration)).

### Transcode on the GPU

```bash
# Decode, scale to 720p and encode on the GPU; audio on the CPU
gst-launch-1.0 -e filesrc location=input.mkv ! decodebin name=d \
    d. ! queue ! vapostproc ! "video/x-raw(memory:VAMemory),width=1280,height=720" ! vah264enc bitrate=2500 ! h264parse ! mp4mux name=m ! filesink location=output.mp4 \
    d. ! queue ! audioconvert ! audioresample ! fdkaacenc ! m.
```

Hardware decoders only accept what the GPU supports: an H.264 High 4:4:4 or an
MPEG-2 4:2:2 stream is not linked to `vah264dec`/`vampeg2dec`. With `decodebin`
the software decoder takes over; with an explicit `vah264dec` the pipeline stops
with `not-linked`.

### Performance Comparison (CPU vs GPU)

Measured on a DS918+ (Intel Celeron J3455, 4 cores, DSM 7.4):

| Pipeline | Input | Time | FPS | Relative to CPU |
|----------|-------|------|-----|-----------------|
| CPU `avdec_h264` → `x264enc` (veryfast) | 20 s H.264 1080p30 | 25.5 s | 24 | baseline |
| GPU `vah264dec` → `vah264enc` | same | 4.0 s | 150 | ~6× faster |
| GPU `vah264dec` → `vah265enc` | same | 21.8 s | 28 | ~1.2× faster |
| CPU decode, scale 720p → `x264enc` | same | 13.1 s | 46 | baseline |
| GPU decode, `vapostproc` 720p → `vah264enc` | same | 2.6 s | 231 | ~5× faster |
| CPU `decodebin` → `x264enc` + `fdkaacenc` | 60 s MPEG-2/AC-3 576p25 | 29.8 s | 50 | baseline |
| GPU `decodebin` → `vah264enc` + `fdkaacenc` | same | 6.2 s | 242 | ~5× faster |

H.265 encoding on this GPU gains little over the CPU; H.264 is the format to
favour for real-time transcoding.

!!! note
    The legacy `gstreamer-vaapi` plugins (`vaapih264dec`, ...) were removed upstream
    in GStreamer 1.28 in favor of the `va` plugin. The OpenMAX wrapper (`gst-omx`),
    discontinued upstream after 1.22, is not provided.

## Troubleshooting

### Plugin not found or blacklisted

GStreamer caches its plugin registry in `~/.cache/gstreamer-1.0/`. After a
package upgrade, remove the cache so plugins are rescanned:

```bash
rm -rf ~/.cache/gstreamer-1.0
gst-inspect-1.0 > /dev/null
```

A plugin that fails to load is blacklisted. List them, then load one directly to
see why:

```bash
gst-inspect-1.0 -b
gst-inspect-1.0 /var/packages/gstreamer/target/lib/gstreamer-1.0/libgsthls.so
# Could not load plugin file: ... libnettle.so.9: cannot open shared object file
```

A missing library that FFmpeg 8 provides (as `libnettle` above) means FFmpeg 8
and GStreamer come from different builds: update FFmpeg 8.

### Debugging a pipeline

Use `GST_DEBUG` to get more information on a failing pipeline:

```bash
GST_DEBUG=3 gst-launch-1.0 ...
```

## Using GStreamer in a package

A package that builds against GStreamer depends on its cross packages, for example
`cross/gstreamer` and `cross/gst-plugins-base`. GStreamer itself takes the FFmpeg
libraries for `gst-libav` from the FFmpeg meta package:

```makefile
FFMPEG_PACKAGE = ffmpeg8
include ../../mk/spksrc.spk-meta.mk
```

## Architecture Support

| Architecture | DSM 6 | DSM 7 | Notes |
|-------------|-------|-------|---------|
| x64 | ✓ | ✓ | VA-API hardware acceleration |
| aarch64 | ✓ | ✓ | |
| armv7 | ✓ | ✓ | |
| i686 (evansport) | ✓ | ✓ | No `dvb` (Linux 3.2 headers) |
| comcerto2k | - | ✓ | No `dvb` (Linux 3.2 headers) |
| ppc (qoriq) | ✓ | - | No `openh264` |
| armv5, hi3535 | - | - | Compiler too old (gcc < 4.9) |

On DSM 6 and comcerto2k (gcc 4.9), the `taglib` plugin (C++17) is not built.

## See Also

- [FFmpeg](ffmpeg.md)
- [SynoCli Video Driver](synocli-videodriver.md)
- [GStreamer documentation](https://gstreamer.freedesktop.org/documentation/)
