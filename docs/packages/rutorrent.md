---
title: ruTorrent
description: Web-based BitTorrent client with rtorrent backend
tags:
  - download
  - torrent
  - web
---

# ruTorrent

ruTorrent is a PHP-based web frontend for the popular command-line BitTorrent client rtorrent.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | rutorrent |
| Upstream | [github.com/Novik/ruTorrent](https://github.com/Novik/ruTorrent) |
| License | GPL-3.0 |
| Default Port | Uses Web Station |

## Installation

1. Install Web Station first (required dependency)
2. Install ruTorrent from Package Center
3. The wizard will ask for a download share location
4. Access via Web Station URL

## Configuration

### Data Locations

- Configuration: `/var/services/web_packages/rutorrent/conf/`
- rtorrent config: `/var/packages/rutorrent/var/rtorrent.rc`
- Download directory: Configured during installation
- Session data: `/var/packages/rutorrent/var/.session/`

### Changing Download Directory

1. Stop ruTorrent package
2. Edit `/var/packages/rutorrent/var/rtorrent.rc`
3. Update `directory.default.set` path
4. Start package

### Plugins

ruTorrent includes many plugins. Enable/disable in the web interface under Settings → Plugins.

Popular plugins:
- **autodl-irssi** - Automated downloading from IRC
- **ratio** - Ratio management
- **scheduler** - Download scheduling
- **unpack** - Automatic extraction

## Troubleshooting

### rtorrent Not Starting

Check rtorrent logs:
```bash
cat /var/packages/rutorrent/var/rtorrent.log
```

### Permission Denied on Downloads

Ensure the `sc-rutorrent` service account has write access to your download share.

### Web Interface Shows Offline

1. Verify rtorrent is running: `synopkg status rutorrent`
2. Check SCGI socket exists: `ls /var/packages/rutorrent/var/scgi.socket`

## Related Packages

- [Transmission](transmission.md) - Alternative torrent client
- qBittorrent - Alternative with built-in web UI
