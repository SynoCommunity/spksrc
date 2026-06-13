---
title: Jellyfin
description: Free software media streaming server
tags:
  - media
  - streaming
  - server
---

# Jellyfin

Jellyfin is a free software media system that puts you in control of managing and streaming your media.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | jellyfin |
| Upstream | [jellyfin.org](https://jellyfin.org/) |
| License | GPL-2.0 |
| Default Port | 8096 |

## Installation

1. Install Jellyfin from Package Center
2. Access web interface at `http://your-nas:8096`
3. Complete initial setup wizard

## Configuration

### Data Location

- Configuration: `/var/packages/jellyfin/var/config/`
- Cache: `/var/packages/jellyfin/var/cache/`
- Log: `/var/packages/jellyfin/var/log/`

### Hardware Transcoding

For Intel-based Synology devices:

1. Install [SynoCli Video Driver](synocli-videodriver.md) package
2. Enable hardware acceleration in Jellyfin Dashboard → Playback → Transcoding
3. Select "Video Acceleration API (VAAPI)" as the hardware acceleration method
4. Set the VA-API device to `/dev/dri/renderD128`

## Troubleshooting

### Permission Issues

Jellyfin runs as the `sc-jellyfin` service account. Ensure this account has read access to your media folders:

1. Open File Station
2. Right-click your media folder → Properties
3. Add `sc-jellyfin` with read permission

### Hardware Transcoding Not Working

1. Verify SynoCli Video Driver is installed
2. Check `/dev/dri/` devices exist
3. Review logs in `/var/packages/jellyfin/var/log/`

## Related Packages

- [FFmpeg](ffmpeg.md) - Transcoding engine
- [SynoCli Video Driver](synocli-videodriver.md) - Hardware acceleration
