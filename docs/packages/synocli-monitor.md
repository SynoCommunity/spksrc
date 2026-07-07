---
title: SynoCli Monitor Tools
description: System monitoring utilities for Synology NAS
tags:
  - cli
  - monitoring
  - tools
---

# SynoCli Monitor Tools

SynoCli Monitor Tools provides system monitoring and performance analysis utilities.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-monitor |
| License | Various (GPL, BSD) |

## Included Tools

| Tool | Description |
|------|-------------|
| nmon | Performance monitor |
| njmon | JSON performance output |
| htop | Interactive process viewer |
| iperf2 | Network bandwidth testing |
| iperf3 | Modern network testing |
| ionice | I/O scheduling priority |
| cpulimit | CPU usage limiter |
| net-snmp | SNMP tools (snmpget, snmpwalk, etc.) |

## Usage Examples

### htop - Process Monitor

```bash
# Launch interactive monitor
htop

# Key bindings:
# F5: Tree view, F6: Sort, F9: Kill, F10: Quit
```

### nmon - Performance Monitor

```bash
# Interactive mode
nmon

# Keys: c=CPU, m=Memory, d=Disk, n=Network, q=Quit

# Capture to file (every 30 sec, 120 samples = 1 hour)
nmon -f -s 30 -c 120
```

### iperf3 - Network Testing

```bash
# Server mode (run on one machine)
iperf3 -s

# Client mode (test against server)
iperf3 -c server.ip.address

# Reverse test (download instead of upload)
iperf3 -c server.ip.address -R
```

### ionice - I/O Priority

```bash
# Run command with low I/O priority
ionice -c 3 rsync -av /source /dest

# Class 3 = idle (only when system is idle)
```

### cpulimit - Limit CPU Usage

```bash
# Limit process to 50% CPU
cpulimit -p <pid> -l 50

# Run command with CPU limit
cpulimit -l 50 -- command args
```

## Related Packages

- [SynoCli Misc Tools](synocli-misc.md) - Miscellaneous utilities
- [Node Exporter](node-exporter.md) - Prometheus metrics
