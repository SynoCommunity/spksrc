---
title: FFmpeg
description: FFmpeg multimedia framework for audio and video processing
tags:
  - media
  - transcoding
  - video
  - audio
---

# FFmpeg

FFmpeg provides a set of command line tools to process audio and video media files.

Commands are located in `/usr/local/ffmpeg<version>/bin` and libraries are required by
other packages. In DSM 7.0+, they are located in `/volume1/@appstore/ffmpeg<version>/bin`.

Symbolic links are made available through `/usr/local/bin` where the latest installed version becomes the default:

- `ffmpeg4`
- `ffmpeg5`
- `ffmpeg6`
- `ffmpeg7`
- `ffmpeg` → Last installed version

## Package Information

| Property | Value |
|----------|-------|
| Package Name | ffmpeg4, ffmpeg5, ffmpeg6, ffmpeg7 |
| Upstream | [ffmpeg.org](https://ffmpeg.org/) |
| License | LGPL/GPL |

## User Permissions

To access video acceleration, users must be in the `videodriver` group.

- Access to the video device file is granted on a per-application basis. This allows an application such as `tvheadend` to be granted access to hardware acceleration when calling `ffmpeg`.
- As a default user you must interact with `ffmpeg` acting as a user whose access was already granted or add your user account to the `videodriver` group.

```bash
# Check current user and groups
id $(whoami)
# Output: uid=1026(<username>) gid=100(users) groups=100(users),101(administrators)

# Add yourself to the videodriver group
sudo synogroup --member videodriver $(whoami)

# Expected output:
# Group Name: [videodriver]
# Group Type: [AUTH_LOCAL]
# Group ID:   [937]
# Group Members:
# 0:[<username>]

# Verify the change took effect
id $(whoami)
# Output should now include: groups=100(users),101(administrators),937(videodriver)

# Log out and log back in for all applications to recognize the new group membership
```

**Alternative:** Run commands as the ffmpeg service user:
```bash
# For FFmpeg7
sudo su -s /bin/bash sc-ffmpeg7 -c 'command'
```

## Hardware Acceleration

For Intel-based Synology devices with DSM 7.1+, hardware transcoding is available through the [SynoCli Video Driver](synocli-videodriver.md) package which provides:

- VA-API support
- Vulkan support (kernel 5.10+ required)
- OpenCL support

### Validate Detection of Your GPU

```bash
lsgpu
# Output:
# card0                    Intel Broxton (Gen9)              drm:/dev/dri/card0
# └─renderD128                                               drm:/dev/dri/renderD128
```

### Validate Intel GPU Hardware Acceleration (VA-API)

On Intel GPUs, `vainfo` validates that hardware video acceleration is correctly exposed through VA-API and that the Intel media driver (iHD) is functional.

```bash
/var/packages/synocli-videodriver/target/bin/vainfo
# Output:
# Trying display: drm
# libva info: VA-API version 1.22.0
# libva info: Trying to open /var/packages/synocli-videodriver/target/lib/iHD_drv_video.so
# libva info: Found init function __vaDriverInit_1_22
# libva info: va_openDriver() returns 0
# vainfo: VA-API version: 1.22 (libva 2.22.0)
# vainfo: Driver version: Intel iHD driver for Intel(R) Gen Graphics - 24.4.4
# vainfo: Supported profile and entrypoints
#       VAProfileNone                   : VAEntrypointVideoProc
#       VAProfileMPEG2Simple            : VAEntrypointVLD
#       VAProfileH264Main               : VAEntrypointVLD
#       VAProfileH264Main               : VAEntrypointEncSlice
#       VAProfileH264High               : VAEntrypointVLD
#       VAProfileHEVCMain               : VAEntrypointVLD
#       VAProfileHEVCMain               : VAEntrypointEncSlice
#       VAProfileVP9Profile0            : VAEntrypointVLD
```

This output confirms:

- The Intel GPU is detected by the kernel
- The Intel Media Driver (iHD) is correctly installed and loadable
- VA-API is functional and able to communicate with the GPU
- Hardware decode, encode and video processing capabilities are exposed

Older Intel processors fall back to the legacy `i965` driver:
```bash
# vainfo: Driver version: Intel i965 driver for Intel(R) CherryView - 2.4.1
```

If access is restricted or non-existent (such as on virtual DSM):
```bash
vainfo
# Trying display: drm
# error: failed to initialize display
```

### Validate Intel Quick Sync (QSV) for Transcoding

```bash
ffmpeg7 -hide_banner -init_hw_device qsv=hw,child_device=/dev/dri/renderD128 \
  -filter_hw_device hw -i input.mp4 \
  -vf 'hwupload=extra_hw_frames=64,scale_qsv=format=nv12' \
  -c:v h264_qsv -preset veryfast output_qsv.mp4
```

If QSV is not properly configured:
```
QSV mapping must be enabled on context creation to use QSV to OpenCL mapping.
[AVHWDeviceContext @ 0x562fdca7bbc0] QSV to OpenCL mapping not usable.
```

### OpenCL Acceleration

Validate OpenCL hardware acceleration (only available on DSM 7+ with recent Intel processors):
```bash
/var/packages/synocli-videodriver/target/bin/clinfo
# Output:
# Number of platforms                               1
#   Platform Name                                   Intel(R) OpenCL Graphics
#   Platform Vendor                                 Intel(R) Corporation
#   Platform Version                                OpenCL 3.0
```

Validate available OpenCL filters:
```bash
ffmpeg7 -hide_banner -filters | grep opencl
# ... avgblur_opencl    V->V       Apply average blur filter
# ... boxblur_opencl    V->V       Apply boxblur filter to input video
# ... nlmeans_opencl    V->V       Non-local means denoiser through OpenCL
# ... scale_opencl      V->V       Scale the input video size through OpenCL
# ... tonemap_opencl    V->V       Perform HDR to SDR conversion with tonemapping
```

Minimal OpenCL filter test:
```bash
ffmpeg7 -benchmark \
  -init_hw_device opencl=ocl \
  -filter_hw_device ocl \
  -f lavfi -i testsrc=duration=10:size=1920x1080:rate=30 \
  -vf "format=nv12,hwupload,boxblur_opencl,hwdownload,format=nv12" \
  -f null -
```

This confirms OpenCL runtime and GPU compute path are operational.

### Vulkan Acceleration

Vulkan may work on Synology models using a 5.10 kernel or newer using <https://github.com/007revad/Transcode_for_x25>.

Vulkan fails on older Synology models:
```bash
/var/packages/synocli-videodriver/target/bin/vulkaninfo
# ERROR: VK_ERROR_INITIALIZATION_FAILED
```

FFmpeg Vulkan initialization failure on older models:
```bash
ffmpeg7 -hide_banner -v verbose -init_hw_device vulkan
# [AVHWDeviceContext @ ...] Device creation failure: VK_ERROR_INITIALIZATION_FAILED
# Failed to set value 'vulkan' for option 'init_hw_device'
```

## Usage with Other Packages

Many media packages depend on FFmpeg:

- [Jellyfin](jellyfin.md) - Hardware transcoding
- [Radarr/Sonarr](radarr-sonarr.md) - Media analysis
- [Home Assistant](homeassistant.md) - Camera streams
- [Navidrome](navidrome.md) - Audio transcoding

## Building Custom FFmpeg

The spksrc framework supports building FFmpeg with custom options. Key Makefile variables:

```makefile
# Enable specific codecs
FFMPEG_CODEC_X264 = 1
FFMPEG_CODEC_X265 = 1
FFMPEG_CODEC_LIBVPX = 1

# Enable hardware acceleration
FFMPEG_VAAPI = 1
```

## Related Packages

- [SynoCli Video Driver](synocli-videodriver.md) - Intel GPU drivers

## Resources

- [FFmpeg Official Documentation](https://ffmpeg.org/documentation.html)
- [FFmpeg Ultimate Guide](https://img.ly/blog/ultimate-guide-to-ffmpeg/)
