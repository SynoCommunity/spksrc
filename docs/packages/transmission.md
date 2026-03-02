---
title: Transmission
description: Lightweight BitTorrent client
tags:
  - download
  - torrent
  - web
---

# Transmission

Transmission is a fast, easy, and free BitTorrent client.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | transmission |
| Upstream | [transmissionbt.com](https://transmissionbt.com/) |
| License | GPL-2.0 |
| Default Port | 9091 |

## Installation

1. Install Transmission from Package Center
2. The wizard will ask for a download share location
3. Access web interface at `http://your-nas:9091`

## Configuration

### Data Locations

- Configuration: `/var/packages/transmission/var/settings.json`
- Download directory: Configured during installation
- Watch directory: `/var/packages/transmission/var/watch/`

### Web Interface

Access the web UI at port 9091. Default has no authentication - configure username/password in settings.

### Settings File

Main configuration is in `/var/packages/transmission/var/settings.json`. Stop the service before editing:

```bash
synopkg stop transmission
vim /var/packages/transmission/var/settings.json
synopkg start transmission
```

### Common Settings

```json
{
    "download-dir": "/volume1/downloads",
    "rpc-authentication-required": true,
    "rpc-username": "admin",
    "rpc-password": "your-password",
    "speed-limit-down": 1000,
    "speed-limit-down-enabled": true
}
```

## Remote Clients

Transmission supports:
- Web interface (built-in)
- Transmission Remote GUI
- Mobile apps (Transmission Remote, etc.)
- Command-line: `transmission-remote`

## Troubleshooting

### Cannot Connect to Web Interface

1. Verify package is running: `synopkg status transmission`
2. Check port 9091 is not blocked
3. Review logs: `/var/packages/transmission/var/transmission.log`

### Permission Denied on Downloads

Ensure `sc-transmission` service account has write access to your download share.

## Related Packages

- [ruTorrent](rutorrent.md) - Alternative with more features
- [Deluge](deluge.md) - Another popular client
- qBittorrent - Qt-based alternative
