---
title: DSM Utilities
description: Helpful DSM configuration for SynoCommunity packages
tags:
  - dsm
  - utilities
  - ssh
---

# DSM Utilities

This page covers common DSM configuration tasks that many SynoCommunity packages require.

## Enable SSH Access

SSH service allows you to gain access to your system with shell command line:

1. In Control Panel, navigate to **Terminal & SNMP**
2. Check **Enable SSH service**
3. Click **Apply**

Use an SSH client like PuTTY or KiTTY on Windows, or the `ssh` command on Linux/macOS to connect to your DiskStation using its hostname or IP address with your username and password.

For more details, see [Synology KB: How to login to DSM with root permission via SSH/Telnet](https://www.synology.com/en-us/knowledgebase/DSM/tutorial/General/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet).

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
