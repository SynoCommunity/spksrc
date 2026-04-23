---
title: rclone
description: Cloud storage sync tool
tags:
  - backup
  - sync
  - cloud
---

# rclone

rclone is a command-line program to sync files and directories to and from cloud storage providers.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | rclone |
| Upstream | [rclone.org](https://rclone.org/) |
| License | MIT |

## Supported Providers

rclone supports 40+ cloud storage providers including:
- Amazon S3 / Google Cloud Storage / Azure Blob
- Google Drive / OneDrive / Dropbox
- SFTP / FTP / WebDAV
- Backblaze B2
- Mega
- pCloud
- Box

## Installation

1. Install rclone from Package Center
2. Configure remotes via SSH

## Configuration

### Interactive Setup

```bash
rclone config

# Follow prompts to add a remote:
# n) New remote
# name> mydrive
# storage> drive  (for Google Drive)
# ...
```

### Configuration File

Config stored at `/var/packages/rclone/var/rclone.conf`

## Usage Examples

### Sync

```bash
# Sync local to remote
rclone sync /volume1/data remote:backup

# Sync remote to local
rclone sync remote:data /volume1/restore

# Dry run first
rclone sync /volume1/data remote:backup --dry-run
```

### Copy

```bash
# Copy files (doesn't delete destination files)
rclone copy /volume1/data remote:backup
```

### Mount

```bash
# Mount remote as filesystem
rclone mount remote:data /mnt/cloud --daemon

# Unmount
fusermount -u /mnt/cloud
```

### List

```bash
# List remotes
rclone listremotes

# List files
rclone ls remote:path

# List directories
rclone lsd remote:path
```

## Scheduled Backups

Use Task Scheduler in DSM:

1. Control Panel → Task Scheduler
2. Create → Scheduled Task → User-defined script
3. Script: `/var/packages/rclone/target/bin/rclone sync /volume1/data remote:backup`

## Troubleshooting

### OAuth Token Expired

Re-authenticate:
```bash
rclone config reconnect remote:
```

### Rate Limiting

Use bandwidth limiting:
```bash
rclone sync ... --bwlimit 10M
```

## Related Packages

- Restic - Backup with rclone backend support
- [BorgBackup](borgbackup.md) - Alternative backup solution
- [Syncthing](syncthing.md) - Continuous sync
