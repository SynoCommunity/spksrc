---
title: SynoCli Development Tools
description: Development and debugging utilities for Synology NAS
tags:
  - cli
  - development
  - tools
---

# SynoCli Development Tools

SynoCli Development Tools provides build tools and debugging utilities.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-devel |
| License | GPL |

## Included Tools

| Tool | Version | Description |
|------|---------|-------------|
| automake | 1.18.1 | Makefile generator |
| autoconf | 2.71 | Configure script generator |
| make | 4.4.1 | Build automation |
| pkg-config | 0.29.2 | Library configuration |
| libtree | 3.1.1 | Library dependency viewer |
| strace | 6.18 | System call tracer |

## Usage Examples

### strace - System Call Tracing

```bash
# Trace system calls
strace command

# Trace specific syscalls
strace -e open,read,write command

# Attach to running process
strace -p <pid>

# Save trace to file
strace -o trace.log command
```

### libtree - Library Dependencies

```bash
# Show library dependencies
libtree /path/to/binary

# Show all dependencies recursively
libtree -v /path/to/binary
```

### pkg-config - Library Info

```bash
# Get compiler flags
pkg-config --cflags openssl

# Get linker flags
pkg-config --libs openssl

# Check if library exists
pkg-config --exists openssl && echo "Found"
```

### Building Software

With these tools, you can compile software directly on your NAS:

```bash
# Typical autotools build
./configure
make
make install
```

## Related Packages

- [Git](git.md) - Version control
- Python packages (python311, python312) - Python development
