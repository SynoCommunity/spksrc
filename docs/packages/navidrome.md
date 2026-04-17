---
title: Navidrome
description: Modern music server and streamer
tags:
  - media
  - music
  - streaming
---

# Navidrome

Navidrome is a self-hosted, open source music server and streamer compatible with Subsonic/Airsonic clients.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | navidrome |
| Upstream | [navidrome.org](https://navidrome.org/) |
| License | GPL-3.0 |
| Default Port | 4533 |

## Features

- Web-based UI
- Subsonic API compatible
- Multi-user support
- Last.fm scrobbling
- Transcoding
- Playlist management

## Installation

1. Install Navidrome from Package Center
2. Set music library path during installation
3. Access web interface at `http://your-nas:4533`
4. Create admin account on first access

## Configuration

### Data Locations

- Configuration: `/var/packages/navidrome/var/navidrome.toml`
- Database: `/var/packages/navidrome/var/navidrome.db`
- Cache: `/var/packages/navidrome/var/cache/`

### Configuration File

```toml
MusicFolder = "/volume1/music"
DataFolder = "/var/packages/navidrome/var"
Port = 4533
BaseUrl = ""
EnableTranscodingConfig = true
TranscodingCacheSize = "100MB"
ImageCacheSize = "100MB"
```

### Transcoding

Navidrome uses FFmpeg for transcoding. Configuration in web UI under Settings → Transcoding.

## Mobile Apps

Subsonic-compatible apps:

- **iOS**: play:Sub, Amperfy, iSub
- **Android**: DSub, Ultrasonic, Symfonium
- **Desktop**: Sonixd, Sublime Music

## Troubleshooting

### Music Not Appearing

1. Check folder permissions
2. Trigger manual scan in UI
3. Review logs for scan errors

### Transcoding Errors

Verify FFmpeg is available and working:
```bash
/var/packages/ffmpeg7/target/bin/ffmpeg -version
```

## Related Packages

- [FFmpeg](ffmpeg.md) - Transcoding support
- [Beets](beets.md) - Music organization
