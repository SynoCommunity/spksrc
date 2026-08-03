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
| aria2c | Download utility |
| arp-scan | ARP network scanner |
| autossh | Automatic SSH reconnection |
| dig / delv / mdig | DNS lookup tools |
| etherwake | Wake-on-LAN utility |
| gensiot | Generic socket I/O tools |
| IMAPFilter | IMAP mail filtering |
| links | Text-mode web browser |
| mtr | Network diagnostic tool |
| nmap / nping / ncat | Network scanner and netcat |
| openssh | SSH client and server tools (ssh, scp, sftp, sshd) |
| rsync | Fast file copying |
| screen | Terminal multiplexer |
| ser2net | Serial-to-network proxy |
| socat | Multipurpose relay |
| sshfs | Mount filesystems over SSH |
| telnet | Telnet client |
| tmux | Modern terminal multiplexer |
| whois | Domain lookup |
| xxhsum | xxHash checksum utility |

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
