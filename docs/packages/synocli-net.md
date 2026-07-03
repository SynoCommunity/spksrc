---
title: SynoCli Network Tools
description: Command-line network utilities for Synology NAS
tags:
  - cli
  - network
  - tools
---

# SynoCli Network Tools

SynoCli Network Tools provides essential command-line networking utilities.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-net |
| License | Various (GPL, BSD) |

## Included Tools

| Tool | Description |
|------|-------------|
| screen | Terminal multiplexer |
| tmux | Modern terminal multiplexer |
| socat | Multipurpose relay |
| nmap | Network scanner |
| arp-scan | ARP network scanner |
| mtr | Network diagnostic tool |
| links | Text-mode web browser |
| rsync | Fast file copying |
| xxhsum | xxHash checksum utility |
| autossh | Automatic SSH reconnection |
| openssh | SSH client and server tools |
| sftp | Secure file transfer |
| scp | Secure copy |
| etherwake | Wake-on-LAN utility |
| telnet | Telnet client |
| whois | Domain lookup |
| sshfs | Mount filesystems over SSH |
| IMAPFilter | IMAP mail filtering |

## Installation

1. Install SynoCli Network Tools from Package Center
2. Tools are added to system PATH
3. Use via SSH terminal

## Usage Examples

### tmux - Terminal Multiplexer

```bash
# Start new session
tmux new -s mysession

# Detach: Ctrl-b d
# Reattach
tmux attach -t mysession

# List sessions
tmux ls
```

### nmap - Network Scanner

```bash
# Scan local network
nmap -sn 192.168.1.0/24

# Scan specific host
nmap -A 192.168.1.100
```

### rsync - File Synchronization

```bash
# Sync local folders
rsync -avz /source/ /destination/

# Sync to remote
rsync -avz /local/path/ user@remote:/path/
```

### mtr - Network Diagnostics

```bash
# Trace route with statistics
mtr google.com
```

### sshfs - Mount Remote Filesystem

```bash
# Mount remote directory
sshfs user@remote:/path /local/mountpoint

# Unmount
fusermount -u /local/mountpoint
```

## Related Packages

- [SynoCli File Tools](synocli-file.md) - File management utilities
- [SynoCli Misc Tools](synocli-misc.md) - Miscellaneous utilities
- [SynoCli Monitor Tools](synocli-monitor.md) - System monitoring
