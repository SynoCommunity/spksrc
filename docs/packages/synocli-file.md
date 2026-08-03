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
| less | Pager for viewing files |
| tree | Directory tree viewer |
| jdupes | Duplicate file finder |
| fdupes | Duplicate file finder |
| rhash | Hash computing/verifying utility |
| mc | Midnight Commander file manager |
| nano | Text editor |
| micro | Modern terminal text editor |
| mg | Micro (GNU) emacs-like text editor |
| jupp | Joe's Own Editor (jmacs, joe, jpico, jstar) |
| rnm | Batch file renamer (regex) |
| file | File type identification |
| fzf | Command-line fuzzy finder |
| rg (ripgrep) | Line-oriented recursive search |
| fd | Simple, fast alternative to `find` |
| sd | Intuitive `sed` alternative |
| bat | Cat clone with syntax highlighting |
| eza | Modern `ls` replacement |
| lsd | Modern `ls` replacement |
| nnn | Terminal file manager |
| detox | Filename cleanup |
| rmlint | Duplicate and lint finder |
| zstd | Zstandard compression |
| lzip / plzip | Lossless data compressor (parallel) |
| pixz | Parallel, indexing `xz` |
| pigz | Parallel `gzip` |
| iconv | Character set conversion |
| dos2unix | Convert line endings |
| xstow | Symlink farm manager |
| patch | Apply patches to files |
| pcre2grep / pcre2test | PCRE2 grep and test tools |

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
