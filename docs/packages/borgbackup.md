---
title: BorgBackup
description: Deduplicating backup program
tags:
  - backup
  - encryption
  - deduplication
---

# BorgBackup

BorgBackup (Borg) is a deduplicating archiver with compression and encryption.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | borgbackup |
| Upstream | [borgbackup.org](https://borgbackup.org/) |
| License | BSD-3-Clause |

## Included Tools

- **borg** - Main backup tool
- **borgmatic** - Configuration-driven backup wrapper
- **emborg** - Alternative Borg frontend

## Installation

1. Install BorgBackup from Package Center
2. Initialize a repository
3. Configure backups

## Basic Usage

### Initialize Repository

```bash
# Local repository
borg init --encryption=repokey /volume1/backup/borg-repo

# Remote repository
borg init --encryption=repokey user@remote:/path/to/repo
```

### Create Backup

```bash
borg create /volume1/backup/borg-repo::backup-{now} \
    /volume1/important \
    --exclude '*.tmp' \
    --compression lz4
```

### List Archives

```bash
borg list /volume1/backup/borg-repo
```

### Restore Files

```bash
# Extract entire archive
borg extract /volume1/backup/borg-repo::backup-name

# Extract specific path
borg extract /volume1/backup/borg-repo::backup-name path/to/file
```

### Prune Old Backups

```bash
borg prune /volume1/backup/borg-repo \
    --keep-daily=7 \
    --keep-weekly=4 \
    --keep-monthly=6
```

## Borgmatic

Borgmatic simplifies Borg with configuration files.

### Configuration

Create `/var/packages/borgbackup/var/borgmatic.yaml`:

```yaml
repositories:
    - path: /volume1/backup/borg-repo
      label: local

source_directories:
    - /volume1/data
    - /volume1/photos

exclude_patterns:
    - '*.tmp'
    - '**/cache'

retention:
    keep_daily: 7
    keep_weekly: 4
    keep_monthly: 6

compression: lz4
encryption_passphrase: "your-passphrase"
```

### Run Borgmatic

```bash
borgmatic create
borgmatic prune
borgmatic check

# Or all at once
borgmatic
```

## Scheduling

Use DSM Task Scheduler:

1. Control Panel → Task Scheduler
2. Create → Scheduled Task → User-defined script
3. Script: `/var/packages/borgbackup/target/env/bin/borgmatic`

## Troubleshooting

### Repository Locked

```bash
# Break lock (only if no backup is running!)
borg break-lock /volume1/backup/borg-repo
```

### Check Repository Health

```bash
borg check /volume1/backup/borg-repo
```

## Related Packages

- Restic - Alternative dedup backup
- [rclone](rclone.md) - Can sync Borg repos to cloud
