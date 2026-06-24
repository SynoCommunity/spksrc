---
title: Mosh
description: Mobile shell - robust SSH replacement
tags:
  - network
  - ssh
  - remote
---

# Mosh

Mosh (mobile shell) is a remote terminal application that supports intermittent connectivity and roaming.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | mosh |
| Upstream | [mosh.org](https://mosh.org/) |
| License | GPL-3.0 |
| Default Port | UDP 60000-61000 |

## Features

- Stays connected through network changes
- Handles high-latency connections
- Provides local echo for responsive typing
- Survives sleep/wake on laptops
- No root required

## Installation

1. Install Mosh from Package Center
2. Open UDP ports 60000-61000 on firewall
3. Install Mosh client on your computer

## Usage

### Connect from Client

```bash
# Basic connection
mosh user@your-nas

# Specify server binary path
mosh --server=/var/packages/mosh/target/bin/mosh-server user@your-nas

# Use specific port
mosh -p 60001 user@your-nas
```

### Port Configuration

Mosh uses UDP ports 60000-61000 by default. To restrict:

```bash
mosh -p 60000 user@your-nas
```

## Client Installation

**macOS:**
```bash
brew install mosh
```

**Linux:**
```bash
sudo apt install mosh  # Debian/Ubuntu
sudo dnf install mosh  # Fedora
```

**Windows:**
Use Windows Terminal with WSL, or Chrome extension "Mosh for Chrome".

## Troubleshooting

### Connection Timeout

1. Verify UDP ports are open: `60000-61000`
2. Check firewall allows UDP traffic
3. Test SSH works first: `ssh user@your-nas`

### Server Binary Not Found

Specify the server path:
```bash
mosh --server=/var/packages/mosh/target/bin/mosh-server user@your-nas
```

### Locale Errors

Set locale on server and client:
```bash
export LC_ALL=en_US.UTF-8
```

## Related Packages

- [SynoCli Network Tools](synocli-net.md) - Contains SSH tools
