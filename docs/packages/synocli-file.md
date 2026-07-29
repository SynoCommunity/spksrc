---
title: SynoCli File Tools
description: Command-line file management utilities for Synology NAS
tags:
  - cli
  - file
  - tools
---

# SynoCli File Tools

SynoCli File Tools provides essential file management utilities for the command line.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-file |
| License | Various (GPL, BSD, MIT) |

## Included Tools

| Tool | Description |
|------|-------------|
| mc | Midnight Commander file manager |
| tree | Directory tree viewer |
| ncdu | NCurses disk usage analyzer |
| less | Pager for viewing files |
| file | File type identification |
| fdupes | Duplicate file finder |
| jq | JSON processor |
| rmlint | Duplicate and lint finder |
| rename | Batch file renaming |
| detox | Filename cleanup |
| nano | Text editor (optional) |
| zstd | Zstandard compression |
| lz4 | LZ4 compression |

## Usage Examples

### mc - Midnight Commander

```bash
# Launch file manager
mc

# Use F keys for operations
# F5: Copy, F6: Move, F8: Delete, F10: Exit
```

### ncdu - Disk Usage Analyzer

```bash
# Analyze current directory
ncdu

# Analyze specific path
ncdu /volume1/data

# Export results
ncdu -o report.json /volume1/
```

### jq - JSON Processing

```bash
# Pretty print JSON
cat data.json | jq .

# Extract specific field
cat data.json | jq '.items[].name'

# Filter results
jq '.[] | select(.status == "active")' data.json
```

### fdupes - Find Duplicates

```bash
# Find duplicates in directory
fdupes -r /volume1/photos

# Find and prompt for deletion
fdupes -rd /volume1/photos
```

### rmlint - Find Lint and Duplicates

```bash
# Scan for issues
rmlint /volume1/data

# Run cleanup script (review first!)
sh rmlint.sh
```

## Related Packages

- [SynoCli Network Tools](synocli-net.md) - Network utilities
- [SynoCli Disk Tools](synocli-disk.md) - Disk utilities
- [SynoCli Misc Tools](synocli-misc.md) - Miscellaneous utilities
