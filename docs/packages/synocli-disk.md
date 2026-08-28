---
title: SynoCli Disk Tools
description: Command-line disk management utilities for Synology NAS
tags:
  - cli
  - disk
  - tools
---

# SynoCli Disk Tools

The `synocli-disk` package provides some disk related tools to advanced Linux users. Most of the tools must be run as privileged user (root) to work or to get access to related resources.

| Tool | Description | License |
|------|-------------|---------|
| [e2fsprogs](http://e2fsprogs.sourceforge.net/) | Ext2/Ext3/Ext4 filesystem userspace utilities (`e2fsck`, `mkfs.ext4`, `tune2fs`, etc.). | GPL |
| [ntfs-3g / ntfsprogs](https://www.tuxera.com/community/open-source-ntfs-3g/) | Third generation read/write NTFS driver and NTFS utilities. | GPLv2 |
| [TestDisk](https://www.cgsecurity.org/wiki/TestDisk) | TestDisk is powerful free data recovery software. | GPLv2+ |
| [ncdu](https://dev.yorhel.nl/ncdu) | Ncdu is a disk usage analyzer with an ncurses interface, designed to find space hogs where you don't have an entire graphical setup available. | MIT |
| [davfs2](http://savannah.nongnu.org/projects/davfs2) | Mount a WebDAV resource as a regular file system. | GPLv3 |
| [lsscsi](http://sg.danny.cz/scsi/lsscsi.html) | The lsscsi command lists information about SCSI devices in Linux. | GPLv2 |
| [dar](http://dar.linux.free.fr/) | DAR is a shell command that backs up from a single file to a whole filesystem, taking care of hard links, Extended Attributes, sparse files, MacOS's file forks, any inode type, etc. | GPLv3 |
| [ddrescue](http://www.gnu.org/software/ddrescue/) | GNU ddrescue is a data recovery tool. It copies data from one file or block device to another, trying hard to rescue data in case of read errors. | GNU GPL |
| [duf](https://github.com/muesli/duf) | Disk Usage/Free Utility - a better `df` alternative. | MIT |
| [gdu](https://github.com/dundee/gdu) | Fast disk usage analyzer with console interface written in Go. | MIT |
| [dua](https://lib.rs/crates/dua-cli) | A tool to conveniently learn about the disk usage of directories, fast. | MIT |
| [dutree](https://ownyourbits.com/2018/03/25/analyze-disk-usage-with-dutree/) | A tool to analyze file system usage written in Rust. | GPLv3 |
| [tdu](https://github.com/josephpaul0/tdu) | Top Disk Usage. Estimates the disk space occupied by all files in a given path and displays a sorted list of the biggest items, similar to the `du -skx` command from GNU Coreutils. | GPLv2 |
| [smartmontools](https://www.smartmontools.org/) | smartmontools contains two utility programs (`smartctl` and `smartd`) to control and monitor storage systems using SMART. When you call `smartctl` you will get the older version of Synology DSM; to call smartctl of this package, call `smartctl7` (or `/usr/local/bin/smartctl` or `/var/packages/synocli-disk/target/sbin/smartctl`). To update the device database call `update-smart-drivedb`. | GPLv2 |
| [mergerfs](https://trapexit.github.io/mergerfs/) | mergerfs is a FUSE based union filesystem geared towards simplifying storage and management of files across numerous commodity storage devices. It is similar to mhddfs, unionfs, and aufs. mergerfs must be run as `root`. | ISC |
| [disktype](https://disktype.sourceforge.net/) | Detects the content format of a disk or disk image by checking for signatures of file systems, partition tables, and boot codes. | MIT |
| [gpart](https://github.com/baruch/gpart) | Gpart is a small tool which tries to guess what partitions are on a PC type, MBR-partitioned hard disk in case the primary partition table was damaged. | GPLv2 |

### davfs2 - Mount WebDAV Shares

Before you can mount webdav folders with davfs2, you have to execute once the following commands [see issue #4466](https://github.com/SynoCommunity/spksrc/issues/4466):

Create links in `/usr/sbin`:
```bash
sudo ln -s /usr/local/bin/mount.davfs /usr/sbin/mount.davfs
sudo ln -s /usr/local/bin/umount.davfs /usr/sbin/umount.davfs
```

Create the user `davfs2:davfs2`:
```bash
sudo synouser --add davfs2 "" "" 0 "" 0
sudo synogroup --add davfs2 davfs2
```

## Related Packages

- [SynoCli File Tools](synocli-file.md) - File management utilities
- [SynoCli Network Tools](synocli-net.md) - Network utilities
