---
title: Syncthing
description: Continuous file synchronization
tags:
  - sync
  - backup
  - p2p
---

# Syncthing

Syncthing is a continuous file synchronization program that syncs files between multiple devices.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | syncthing |
| Upstream | [syncthing.net](https://syncthing.net/) |
| License | MPL-2.0 |
| Default Port | 8384 (Web UI), 22000 (Sync) |

## Features

- Peer-to-peer sync (no cloud required)
- End-to-end encryption
- Versioning
- Selective sync
- Cross-platform

## Installation

1. Install Syncthing from Package Center
2. Access web interface at `http://your-nas:8384`

## Configuration

### Add Devices

1. Get device ID from each Syncthing instance (Actions → Show ID)
2. Add Remote Device with the ID
3. Accept on both sides

### Share Folders

1. Add Folder in web UI
2. Set folder path on NAS
3. Share with connected devices
4. Accept share on remote devices

### Folder Settings

- **Send Only** - One-way sync from this device
- **Receive Only** - One-way sync to this device  
- **Send & Receive** - Full two-way sync

### Versioning

Enable file versioning in folder settings:
- Simple File Versioning
- Staggered File Versioning
- External Versioning
- Trash Can Versioning

## Data Locations

- Configuration: `/var/packages/syncthing/var/config/`
- Index database: `/var/packages/syncthing/var/index/`

## Troubleshooting

### Devices Not Connecting

1. Check port 22000 is accessible
2. Enable global/local discovery
3. Try adding relay servers

### Slow Sync

1. Check network settings
2. Increase folder rescan interval
3. Exclude unnecessary files/folders

### Logs

View logs in web UI or `/var/packages/syncthing/var/syncthing.log`

## Related Packages

- [rclone](rclone.md) - Cloud storage sync
- Restic - Backup solution
