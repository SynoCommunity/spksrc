---
title: Deluge
description: Lightweight BitTorrent client
tags:
  - download
  - torrent
  - web
---

# Deluge

Deluge is a lightweight, cross-platform BitTorrent client with a full web interface.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | deluge |
| Upstream | [deluge-torrent.org](https://deluge-torrent.org/) |
| License | GPL-3.0 |
| Default Port | 8112 (Web UI) |

## Installation

1. Install Deluge from Package Center
2. Access web interface at `http://your-nas:8112`
3. Default password: `deluge`

## Configuration

### Data Locations

- Configuration: `/var/packages/deluge/var/`
- Download directory: Configure in web UI

### First Login

1. Access web UI at port 8112
2. Connect to daemon (should auto-connect)
3. Change default password immediately!

### Preferences

Key settings in Preferences:
- **Downloads**: Download location, move completed
- **Network**: Ports, encryption
- **Bandwidth**: Speed limits
- **Daemon**: Port, authentication

## Plugins

Enable plugins in Preferences → Plugins:

- **AutoAdd** - Watch folder for torrent files
- **Blocklist** - IP blocklist support
- **Execute** - Run commands on events
- **Extractor** - Auto-extract archives
- **Label** - Organize with labels
- **Scheduler** - Schedule speed limits

## Troubleshooting

### Cannot Connect to Daemon

1. Verify daemon is running
2. Check daemon port (default: 58846)
3. Review logs: `/var/packages/deluge/var/deluged.log`

### Web UI Connection Issues

1. Check web UI is enabled
2. Verify port 8112 is accessible
3. Review logs: `/var/packages/deluge/var/deluge-web.log`

## Related Packages

- [Transmission](transmission.md) - Simpler alternative
- qBittorrent - Qt-based client
- [ruTorrent](rutorrent.md) - rtorrent with web UI
