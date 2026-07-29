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

Versioned symbolic links are made available through `/usr/local/bin`, one pair per installed version (no unversioned `ffmpeg`/`ffprobe` link):

- `ffmpeg4`, `ffmpeg5`, `ffmpeg6`, `ffmpeg7`, `ffmpeg8`
- `ffprobe4`, `ffprobe5`, `ffprobe6`, `ffprobe7`, `ffprobe8`

```bash
ls -l /usr/local/bin/ff*
# ffmpeg8  -> /var/packages/ffmpeg8/target/bin/ffmpeg8
# ffprobe8 -> /var/packages/ffmpeg8/target/bin/ffprobe8
# ...
```

## Package Information

| Property | Value |
|----------|-------|
| Package Name | ffmpeg4, ffmpeg5, ffmpeg6, ffmpeg7, ffmpeg8 |
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

### Verify FFmpeg Hardware Acceleration Support

Before validating individual acceleration paths, confirm that FFmpeg itself was built with hardware acceleration support. The frameworks are enabled at build time — if a method is missing here, FFmpeg cannot use it regardless of driver availability.

```bash
ffmpeg7 -hide_banner -hwaccels
# Hardware acceleration methods:
# vaapi    (Intel media driver)
# qsv      (Intel Quick Sync Video)
# drm      (direct render node access)
# opencl   (GPU compute filters)
# vulkan   (work-in-progress)
```

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

FFmpeg's Vulkan filters (`libplacebo`, `scale_vulkan`, `overlay_vulkan`, ...) run
on the Vulkan device provided by the [SynoCli Video Driver](synocli-videodriver.md)
(Mesa `anv`). Whether they are **runtime-usable** depends on the Synology **kernel**,
and there are two distinct failure tiers.

**Tier 1 — Vulkan does not initialize at all (oldest models):**
```bash
/var/packages/synocli-videodriver/target/bin/vulkaninfo
# ERROR: VK_ERROR_INITIALIZATION_FAILED

ffmpeg8 -hide_banner -v verbose -init_hw_device vulkan
# [AVHWDeviceContext @ ...] Device creation failure: VK_ERROR_INITIALIZATION_FAILED
# Failed to set value 'vulkan' for option 'init_hw_device'
```

**Tier 2 — Vulkan initializes, but filters fail (e.g. DS918+, Apollo Lake, DSM kernel 4.4.302+):**

Here `vulkaninfo` sees the GPU and `ffmpeg -init_hw_device vulkan` succeeds, but any
filter that uploads a frame to the GPU fails, because FFmpeg needs to export an
**external Vulkan semaphore** for CPU↔GPU synchronization and the 4.4 kernel does not
provide the required support (DRM `syncobj` / `sync_file` timeline export):

```bash
export VK_ICD_FILENAMES=/var/packages/synocli-videodriver/target/etc/vulkan/icd.d/intel_icd.x86_64.json
vulkaninfo --summary        # OK: GPU0 = Intel(R) HD Graphics 500 (APL 2), Mesa anv 23.3.6

ffmpeg8 -init_hw_device vulkan=vk:0 -filter_hw_device vk \
  -f lavfi -i testsrc=size=1920x1080:rate=25:duration=3 \
  -vf "format=yuv420p,hwupload,libplacebo=w=1280:h=720,hwdownload,format=yuv420p" -f null -
# Failed to create semaphore: VK_ERROR_INVALID_EXTERNAL_HANDLE
# [Parsed_hwupload_1] Failed to configure output pad on Parsed_hwupload_1
# Error reinitializing filters!
```

This is a platform/kernel limitation, not a packaging issue: `libplacebo` is built and
loadable (`ffmpeg8 -buildconf | grep libplacebo`), but the Vulkan frame pipeline cannot
run. It affects **all** Vulkan filters, not just `libplacebo`.

!!! note "It may work on newer Synology models"
    Models shipping a newer kernel (5.10+, e.g. via
    <https://github.com/007revad/Transcode_for_x25>) may expose the external-semaphore
    support that the Vulkan filters need. If Vulkan filtering works on your NAS, please
    [open an issue on spksrc](https://github.com/SynoCommunity/spksrc/issues) with your
    model, DSM version, `uname -r` and the `ffmpeg ... libplacebo ...` result so we can
    document the working configurations.

For a functional HDR→SDR / GPU filtering path on current Synology kernels, use **OpenCL**
(`tonemap_opencl`, see above) or **VA-API**, which do not require external-semaphore export.

### Choosing an Acceleration Path

| Acceleration | Primary use case |
|--------------|------------------|
| VA-API | Hardware decode/encode and basic video processing |
| QSV | High-performance Intel video processing and encoding |
| OpenCL | GPU-accelerated image and video compute filters |
| CPU | Fallback / reference / maximum compatibility |

### Performance Comparison (CPU vs GPU)

Benchmarks on the same system using FFmpeg 7.0.3 with identical input, duration, filters and output settings:

| Path | FPS | Speed | Real time | Relative to CPU |
|------|-----|-------|-----------|-----------------|
| CPU | 13 | 0.419× | 23.9 s | baseline |
| VA-API | 17 | 0.559× | 17.9 s | ~1.3× faster |
| OpenCL | 21 | 0.686× | 14.6 s | ~1.6× faster |
| QSV | 23 | 0.773× | 12.9 s | ~1.8× faster |

- **CPU**: reference baseline, slowest but lowest memory usage
- **VA-API**: moderate speedup, best suited for decode/encode acceleration
- **OpenCL**: good acceleration for GPU-based filters, higher memory usage
- **QSV**: best overall performance on Intel GPUs

## Usage with Other Packages

Many media packages depend on FFmpeg:

- [Jellyfin](jellyfin.md) - Hardware transcoding
- [Radarr/Sonarr](radarr-sonarr.md) - Media analysis
- [Home Assistant](homeassistant.md) - Camera streams
- [Navidrome](navidrome.md) - Audio transcoding

## Using FFmpeg in a package

A package selects which FFmpeg version to build against with `FFMPEG_PACKAGE` and includes `spksrc.spk-meta.mk`, which provides FFmpeg's libraries through the shared staging (see [Build Architecture](../framework/architecture.md#meta-package-dependencies)):

```makefile
FFMPEG_PACKAGE = ffmpeg7
include ../../mk/spksrc.spk-meta.mk
```

The FFmpeg build itself is defined in `cross/ffmpeg<major>` (e.g. `cross/ffmpeg7`). Codecs and features are enabled there through standard FFmpeg `CONFIGURE_ARGS`, and the codec libraries are pulled in as dependencies, for example:

```makefile
CONFIGURE_ARGS += --enable-gpl --enable-version3 --enable-shared
OPTIONAL_DEPENDS += cross/openh264 cross/libaom cross/svt-av1
```

## Related Packages

- [SynoCli Video Driver](synocli-videodriver.md) - Intel GPU drivers

## Resources

- [FFmpeg Official Documentation](https://ffmpeg.org/documentation.html)
- [FFmpeg Ultimate Guide](https://img.ly/blog/ultimate-guide-to-ffmpeg/)
