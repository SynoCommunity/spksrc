---
title: SynoCli Disk Tools
description: Command-line disk management utilities for Synology NAS
tags:
  - cli
  - disk
  - tools
---

# SynoCli Disk Tools

SynoCli Disk Tools provides essential disk management and recovery utilities.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-disk |
| License | Various (GPL, LGPL) |

## Included Tools

| Tool | Description |
|------|-------------|
| dar | Disk archive (full filesystem backups) |
| davfs2 | Mount WebDAV shares |
| ddrescue | Data recovery tool |
| disktype | Detect disk/image content format |
| dua | Disk usage analyzer |
| duf | Disk usage/free utility (better `df`) |
| dutree | Disk usage analyzer (Rust) |
| e2fsprogs | ext2/3/4 filesystem utilities (e2fsck, mkfs.ext4, etc.) |
| gdu | Fast disk usage analyzer (Go) |
| gpart | Recover damaged partition tables |
| lsscsi | List SCSI devices |
| mergerfs | FUSE union filesystem (run as root) |
| ncdu | NCurses disk usage analyzer |
| ntfs-3g | NTFS read/write support |
| ntfsprogs | NTFS utilities |
| smartmontools | SMART disk monitoring (smartctl, smartd) |
| tdu | Top disk usage |
| testdisk | Data recovery tool |

## Usage Examples

### testdisk - Data Recovery

```bash
# Launch interactive recovery
sudo testdisk

# Select disk and follow prompts
# Can recover deleted partitions and files
```

### ddrescue - Disk Imaging

```bash
# Create rescue image of failing disk
sudo ddrescue /dev/sdb /volume1/backup/disk.img /volume1/backup/disk.log

# Resume interrupted recovery
sudo ddrescue -r3 /dev/sdb /volume1/backup/disk.img /volume1/backup/disk.log
```

### davfs2 - Mount WebDAV

```bash
# Mount WebDAV share
sudo mount -t davfs https://webdav.server/path /mnt/webdav

# Add to /etc/fstab for persistent mount
https://webdav.server/path /mnt/webdav davfs user,noauto 0 0
```

### lsscsi - List SCSI Devices

```bash
# Show all SCSI devices
lsscsi

# Verbose output
lsscsi -v
```

### e2fsprogs - Filesystem Operations

```bash
# Check filesystem (must be unmounted)
sudo e2fsck -f /dev/sdb1

# Show filesystem info
sudo tune2fs -l /dev/sdb1
```

## Related Packages

- [SynoCli File Tools](synocli-file.md) - File management utilities
- [SynoCli Network Tools](synocli-net.md) - Network utilities
