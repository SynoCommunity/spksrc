---
title: SynoCli Misc Tools
description: Miscellaneous command-line utilities for Synology NAS
tags:
  - cli
  - misc
  - tools
---

# SynoCli Misc Tools

SynoCli Misc Tools provides various useful command-line utilities.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-misc |
| License | Various (GPL, BSD, MIT) |

## Included Tools

| Tool | Description |
|------|-------------|
| bc / dc | Arbitrary precision calculator |
| cal | Calendar display |
| col | Filter reverse line feeds |
| colcrt | Filter for terminal processing |
| colrm | Remove columns from a file |
| column | Columnate lists |
| dialog | Display dialog boxes from shell scripts |
| errno | Lookup errno names and descriptions |
| expect | Automate interactive applications |
| findmnt | Find mounted filesystems |
| hardlink | Link duplicate files |
| hexdump | Display file in hexadecimal |
| ifdata | Get network interface info |
| ifne | Run command if stdin not empty |
| isutf8 | Check if input is valid UTF-8 |
| lckdo | Execute a command with a lock held |
| lsblk | List block devices |
| lscpu | Display CPU information |
| lsipc | IPC information |
| lsirq | IRQ information |
| mispipe | Pipe while preserving exit status |
| parallel | Parallel command execution |
| pee | Tee standard input to pipes |
| rev | Reverse lines of a file |
| sponge | Soak up stdin and write to file |
| ts | Timestamp input lines |
| uhubctl | USB hub power control |
| wall | Write to all users |
| whereis | Locate commands |
| zramctl | ZRAM management |

## Usage Examples

### parallel - Parallel Execution

```bash
# Process files in parallel
ls *.jpg | parallel convert {} -resize 50% small_{}

# Run 4 jobs in parallel
parallel -j 4 gzip ::: *.log
```

### expect - Automation

```bash
# Automate SSH login (example script)
expect <<'EOF'
spawn ssh user@host
expect "password:"
send "mypassword\r"
interact
EOF
```

### sponge - Safe In-Place Editing

```bash
# Edit file in place safely
sort file.txt | sponge file.txt

# Without sponge, this would empty the file
```

### ts - Add Timestamps

```bash
# Add timestamps to output
command | ts '[%Y-%m-%d %H:%M:%S]'
```

### uhubctl - USB Power Control

```bash
# List USB hubs
uhubctl

# Power off USB port
uhubctl -a off -p 1
```

## Related Packages

- [SynoCli File Tools](synocli-file.md) - File utilities
- [SynoCli Network Tools](synocli-net.md) - Network utilities
