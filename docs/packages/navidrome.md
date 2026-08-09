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

## Synced Lyrics

Navidrome displays synchronized lyrics from embedded tags, `.lrc` sidecar files next to your music, or (for synced lyrics fetched from external providers) a lyrics plugin.

> [!NOTE]
> The web UI does not display lyrics fetched by plugins — use a third-party client such as Symfonium or DSub. If you only use the web UI, place `.lrc` files next to your music files instead (Navidrome reads them natively).

### Installing a Lyrics Plugin

The package data lives in `/var/packages/navidrome/var`, so the plugin folder is `/var/packages/navidrome/var/plugins`. The package runs as user `sc-navidrome`.

1. Download the plugin into the plugins folder (run as the package user to avoid permission issues):

   ```sh
   sudo -u sc-navidrome curl -L -o /var/packages/navidrome/var/plugins/nd-lyrics.ndp \
     https://github.com/J0R6IT0/navidrome-lyrics-plugin/releases/latest/download/nd-lyrics.ndp
   ```

2. Add `nd-lyrics` to `LyricsPriority` in the configuration file:

   ```sh
   sudo -u sc-navidrome vi /var/packages/navidrome/var/navidrome.toml
   ```
   ```toml
   LyricsPriority = ".ttml,.yaml,.yml,.elrc,.lrc,.srt,.txt,embedded,nd-lyrics"
   ```

3. In the web UI (Administration → Plugins), open **nd-lyrics**, enable the **Library** permission (Allow all libraries and write access), save, then enable the plugin.

4. Restart Navidrome for the plugin to be picked up:

   ```sh
   synopkg restart navidrome
   ```

5. Connect with a third-party client (Symfonium, DSub, etc.) — lyrics are fetched on demand.

The [Navidrome Lyrics Plugin](https://github.com/J0R6IT0/navidrome-lyrics-plugin) fetches synced lyrics (LRC/ELRC) from providers such as LRCLIB, NetEase, QQ Music and KuGou.

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
