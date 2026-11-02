---
title: DSM Configuration
description: Common DSM configuration tasks for SynoCommunity packages
tags:
  - dsm
  - configuration
  - ssh
---

# DSM Configuration

This page covers common DSM configuration tasks that many SynoCommunity packages require.

## SSH Access

Many packages require SSH access for configuration or troubleshooting. See [SSH Access](ssh.md) for enabling SSH, connecting from your computer, running commands as root, and security recommendations.

## Enable User Home Directories

Some command line applications require user HOME directories to exist for saving configurations or data.

1. In DSM Control Panel, navigate to **User** section
2. Select the **Advanced** tab
3. Under **User Home**, check **Enable user home service**
4. Click **Apply**

## Synology Diagnosis Tool (synogear)

!!! note
    This is not a SynoCommunity package but Synology's built-in diagnostic tools.

### Installation

Connect via SSH with an administrative account that has `sudo` rights.

```bash
# Switch to root
sudo -s

# Check if already installed
synogear list
# If not installed, output will show:
# Tools are not installed yet. You can run this command to install it:
#    synogear install

# Install
synogear install
```

### Available Tools (DSM 6)

```
addr2line, ar, arping, as, capsh, dig, fio, free, gdb, gdbserver,
getcap, iftop, iostat, iotop, iperf, iperf3, ldd, lsof, ltrace,
mpstat, ncat, nethogs, nm, nmap, nping, nslookup, perf-check.py,
pgrep, pidof, pidstat, ping, ping6, pkill, pmap, ps, pstree, slabtop,
sockstat, speedtest-cli.py, strace, sysstat, tcpdump_wrapper, telnet,
tmux, top, tracepath, traceroute6, vmstat, watch, zmap
```

### Available Tools (DSM 7)

```
autojump, cifsiostat, domain_test.sh, file, fio, free, iftop, iostat,
iotop, iperf3, lsof, mpstat, ncat, nethogs, nmap, nping, nslookup,
nsupdate, perf-check.py, pgrep, pidof, pidstat, pkill, pmap, ps,
slabtop, sockstat, speedtest-cli.py, sysstat, tcpdump, telnet, tmux,
top, vmstat, watch, zmap
```

### Usage

You can invoke available tools either as `root` or with a regular account:

```bash
/var/packages/DiagnosisTool/target/tool/nmap --version

# Nmap version 6.47 ( http://nmap.org )
# Platform: i686-pc-linux-gnu
```

### Uninstall

From Package Center, select the "Diagnosis Tool" package and choose **Uninstall**.

Or via command line:
```bash
synogear remove
# DiagnosisTools are removed completely, you can issue exit to close this session.
```
