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
| bat | Cat clone with syntax highlighting |
| detox | Filename cleanup |
| dos2unix | Convert line endings |
| eza | Modern `ls` replacement |
| fd | Simple, fast alternative to `find` |
| fdupes | Duplicate file finder |
| file | File type identification |
| fzf | Command-line fuzzy finder |
| iconv | Character set conversion |
| jdupes | Duplicate file finder |
| jupp | Joe's Own Editor (jmacs, joe, jpico, jstar) |
| less | Pager for viewing files |
| lsd | Modern `ls` replacement |
| lzip / plzip | Lossless data compressor (parallel) |
| mc | Midnight Commander file manager |
| mg | Micro (GNU) emacs-like text editor |
| micro | Modern terminal text editor |
| nano | Text editor |
| nnn | Terminal file manager |
| patch | Apply patches to files |
| pcre2grep / pcre2test | PCRE2 grep and test tools |
| pigz | Parallel `gzip` |
| pixz | Parallel, indexing `xz` |
| rg (ripgrep) | Line-oriented recursive search |
| rhash | Hash computing/verifying utility |
| rmlint | Duplicate and lint finder |
| rnm | Batch file renamer (regex) |
| sd | Intuitive `sed` alternative |
| tree | Directory tree viewer |
| xstow | Symlink farm manager |
| zstd | Zstandard compression |

## Usage Examples

### mc - Midnight Commander

```bash
# Launch file manager
mc

# Use F keys for operations
# F5: Copy, F6: Move, F8: Delete, F10: Exit
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
