---
title: SynoCli Monitor Tools
description: System monitoring utilities for Synology NAS
tags:
  - cli
  - monitoring
  - tools
---

# SynoCli Monitor Tools

The `synocli-monitor` package provides some monitoring related tools to advanced Linux users.

| Tool | Description | License |
|------|-------------|---------|
| [busybox](https://busybox.net/) | This package includes some process utilities provided by busybox: `iostat`, `pgrep`, `pmap`, `watch` (and `pstree` on DSM 5). | GPL |
| [ionice](https://github.com/karelzak/util-linux) | `ionice` - set or get process I/O scheduling class and priority. It is part of util-linux, a random collection of Linux utilities. | GPLv2 |
| [lsof](https://lsof.readthedocs.io/) | lsof is a command listing open files. | [License](https://github.com/lsof-org/lsof/blob/master/COPYING) |
| [nmon / njmon](http://nmon.sourceforge.net/) | nmon (Nigel's performance Monitor) is a performance monitoring tool for Linux. njmon is similar but saves data to JSON format for a new generation of online time-series databases and web-browser graphing. | GPLv3 |
| [iperf2](https://sourceforge.net/projects/iperf2/) | A tool for measuring TCP and UDP network performance, based on iperf 2.0.5. | BSD |
| [iperf3](https://iperf.fr/) | The iperf series of tools perform active measurements to determine the maximum achievable bandwidth on IP networks. It supports tuning of various parameters related to timing, protocols, and buffers. | three clause BSD |
| [htop](https://hisham.hm/htop/) | Interactive text-mode process viewer for Unix systems. You need to call this with the full path, as an older version of htop is included in DSM 5.1 and newer. | GPLv2 |
| [btop](https://github.com/aristocratos/btop/) | Resource monitor that shows usage and stats for processor, memory, disks, network and processes. | Apache 2.0 |
| [cpulimit](https://github.com/opsengine/cpulimit/) | CPU usage limiter for Linux. | GPLv2+ |
| [bandwhich](https://github.com/imsnif/bandwhich#readme) | CLI utility for displaying current network utilization by process, connection and remote IP/hostname. | MIT |
| [btm (bottom)](https://clementtsang.github.io/bottom) | A customizable cross-platform graphical process/system monitor for the terminal. | MIT |
| [procs](https://github.com/dalance/procs#readme) | A modern replacement for ps written in Rust. | MIT |
| [net-snmp](http://www.net-snmp.org/) | Simple Network Management Protocol (SNMP) is a widely used protocol for monitoring the health and welfare of network equipment. Net-SNMP is a suite of applications used to implement SNMP v1, v2c and v3 using both IPv4 and IPv6. Only command line tools are included in the synocli-monitor package. The daemon `snmpd` is provided by Synology and running on DSM when activated. Synology provides a single command line tool `snmpwalk`; that's why you have to use the full qualified name if you want to run snmpwalk provided by this package. | MIT |
| [lm-sensors](https://hwmon.wiki.kernel.org/) | lm-sensors provides user-space support for the hardware monitoring drivers in Linux 2.6.5 and later (`sensors`, `sensors-detect`, `fancontrol`). | GPLv2 |

## Related Packages

- [SynoCli Misc Tools](synocli-misc.md) - Miscellaneous utilities
- [Node Exporter](node-exporter.md) - Prometheus metrics
