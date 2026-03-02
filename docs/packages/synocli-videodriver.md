---
title: SynoCli Video Driver
description: Intel GPU drivers for hardware acceleration
tags:
  - driver
  - gpu
  - transcoding
---

# SynoCli Video Driver

Provides Intel GPU acceleration support including VA-API, Vulkan, and OpenCL.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-videodriver |
| License | MIT/Intel |
| Requirements | Intel-based Synology (x64) |

## Features

- **VA-API** - Video Acceleration API for encoding/decoding
- **Vulkan** - Modern graphics API (DSM 7.1+)
- **OpenCL** - GPU compute (DSM 7.1+)

## Supported Hardware

Intel-based Synology models with compatible GPUs:
- Apollo Lake (DS918+, DS418play, DS718+, etc.)
- Denverton (DS1621+, DS1821+, RS1221+, etc.)
- Coffee Lake (DVA models)
- Newer Intel platforms

## Installation

1. Install SynoCli Video Driver from Package Center
2. Drivers are loaded automatically
3. Configure applications to use hardware acceleration

## Verification

### Check Device Nodes

```bash
ls -la /dev/dri/
# Should show: card0, renderD128
```

### Test VA-API

```bash
vainfo
# Shows supported profiles and entrypoints
```

### Test Vulkan (DSM 7.1+)

```bash
vulkaninfo --summary
```

## Application Configuration

### Jellyfin

1. Dashboard → Playback → Transcoding
2. Hardware acceleration: Video Acceleration API (VAAPI)
3. VA-API Device: `/dev/dri/renderD128`

### FFmpeg

```bash
# Hardware-accelerated encoding
ffmpeg -hwaccel vaapi -hwaccel_output_format vaapi \
    -i input.mp4 -c:v h264_vaapi output.mp4
```

### Home Assistant

For camera streams with hardware decoding, configure FFmpeg options.

## Troubleshooting

### No /dev/dri Devices

1. Verify Intel-based hardware
2. Check kernel modules are loaded
3. Review package logs

### Permission Denied

Service accounts need access to `/dev/dri/` devices. Some packages handle this automatically; others may need manual configuration.

### VAAPI Errors

```bash
# Check VAAPI driver
export LIBVA_DRIVER_NAME=iHD
vainfo
```

## Related Packages

- [FFmpeg](ffmpeg.md) - Media transcoding
- [Jellyfin](jellyfin.md) - Media server
- [Home Assistant](homeassistant.md) - Camera streams
