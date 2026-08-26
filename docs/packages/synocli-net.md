---
title: SynoCli Network Tools
description: Command-line network utilities for Synology NAS
tags:
  - cli
  - network
  - tools
---

# SynoCli Network Tools

The `synocli-net` package provides some network related tools to advanced Linux users.

!!! note

    With synocli-net >= v2.0 the fritzctl tool is not bundled anymore. The respective github project is archived and it fails to build with newer golang compilers.

| Tool | Description | License |
|------|-------------|---------|
| [nmap (`nmap`, `ncat`, `nping`, `ndiff`)](https://nmap.org/) | Nmap ("Network Mapper") is a free and open source utility for network discovery and security auditing. | GPLv2 |
| [netcat](https://netcat.sourceforge.net/) | Netcat is a featured networking utility which reads and writes data across network connections, using the TCP/IP protocol. | GPLv2 |
| [tmux](http://tmux.github.io) | tmux is a terminal multiplexer; it enables a number of terminals or windows to be accessed and controlled from a single terminal. tmux is intended to be a simple, modern, BSD-licensed alternative to programs such as GNU screen. | BSD |
| [screen](http://www.gnu.org/software/screen/) | Screen is a full-screen window manager that multiplexes a physical terminal between several processes, typically interactive shells. | GPLv2 |
| [sshfs](https://github.com/libfuse/sshfs) | sshfs is a network filesystem client to connect to SSH servers. | GPLv2 |
| [socat](http://www.dest-unreach.org/socat/) | socat (SOcket CAT) is a command line based utility that establishes two bidirectional byte streams and transfers data between them. Because the streams can be constructed from a large set of different types of data sinks and sources, it can be used for many different purposes. | GPLv2 |
| [ser2net](http://ser2net.sourceforge.net/) | Serial port to network proxy. ser2net provides a way for a user to connect from a network connection to a serial port. | GPLv2 |
| [arp-scan](https://github.com/royhills/arp-scan/wiki) | Command-line tool for system discovery and fingerprinting. It constructs and sends ARP requests to the specified IP addresses, and displays any responses that are received. For fingerprinting and resource updates the `Perl` package is required. | MIT |
| [links](http://links.twibright.com/) | Links is a web browser running in text mode. | GPLv2 |
| [IMAPFilter](https://github.com/lefcha/imapfilter/) | IMAPFilter is a mail filtering utility. It connects to remote mail servers using IMAP, sends searching queries to the server and processes mailboxes based on the results. It can be used to delete, copy, move, flag, etc. messages residing in mailboxes. IMAPFilter uses the Lua programming language as a configuration and extension language. | MIT |
| [mtr](https://www.bitwizard.nl/mtr/) | `My traceroute` (mtr) combines the functionality of the 'traceroute' and 'ping' programs in a single network diagnostic tool. | GPLv2 |
| [etherwake](https://linux.die.net/man/8/ether-wake) | Generate and transmit a Wake-On-LAN (WOL) Magic Packet. | GPL |
| [aria2 (`aria2c`)](https://aria2.github.io/) | aria2 is a lightweight multi-protocol and multi-source command-line download utility. It supports HTTP/HTTPS, FTP, SFTP, BitTorrent and Metalink. | GPLv2 |
| [autossh](https://www.harding.motd.ca/autossh/) | Automatically restart SSH sessions and tunnels. | BSD-style |
| [gensio (`gensiot`, `gsh`, `gtlssh`)](https://github.com/cminyard/gensio) | gensio is a library to abstract stream I/O like serial port, TCP, telnet, UDP, SSL, IPMI SOL, etc. The package provides the `gensiot` generic serial port, `gsh` secure shell and `gtlssh` telnet tools. | GPLv2 |
| [openssh](https://www.openssh.com/) | Open source version of SSH connectivity tools (`ssh`, `scp`, `sftp`, `sshd`). | BSD-style |
| [telnet](https://manpages.debian.org/bookworm/inetutils-telnet/telnet.1.en.html) and [whois](https://manpages.debian.org/bookworm/whois/whois.1.en.html) from [inetutils](https://www.gnu.org/software/inetutils/) | GNU network utilities. | GPLv3 |
| [dig](https://manpages.debian.org/bookworm/bind9-dnsutils/dig.1.en.html), [mdig](https://manpages.debian.org/bookworm/bind9-dnsutils/mdig.1.en.html), [delv](https://manpages.debian.org/bookworm/bind9-dnsutils/delv.1.en.html) and [arpaname](https://manpages.ubuntu.com/manpages/noble/man1/arpaname.1.html) from [ISC](https://www.isc.org/) | BIND (Berkeley Internet Name Domain) is a complete, highly portable implementation of the DNS (Domain Name System) protocol. | MPL 2.0 |
| [rsync](https://rsync.samba.org/) | Rsync is a fast and extraordinarily versatile file copying tool. It can copy locally, to/from another host over any remote shell, or to/from a remote rsync daemon. It is famous for its delta-transfer algorithm, which reduces the amount of data sent over the network by sending only the differences between the source files and the existing files in the destination. | GPLv3 |
| [xxHash (`xxhsum`)](https://xxhash.com/) | xxHash is an extremely fast non-cryptographic hash algorithm, working at RAM speed limit. It is proposed in four flavors (XXH32, XXH64, XXH3_64bits and XXH3_128bits). | 2-Clause BSD |

## Related Packages

- [SynoCli File Tools](synocli-file.md) - File management utilities
- [SynoCli Misc Tools](synocli-misc.md) - Miscellaneous utilities
- [SynoCli Monitor Tools](synocli-monitor.md) - System monitoring
