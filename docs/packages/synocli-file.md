---
title: SynoCli File Tools
description: Command-line file related utilities for Synology NAS
tags:
  - cli
  - file
  - tools
---

# SynoCli File Tools

SynoCli File Tools provides essential file related utilities for the command line.

## Package Information

| Property | Value |
|----------|-------|
| Package Name | synocli-file |
| License | Various (see below) |

## Included Tools

### General Tools

| Tool | Description | License |
|------|-------------|---------|
| [detox](https://github.com/dharple/detox#readme) | Detox is a utility designed to clean up filenames. It replaces difficult to work with characters, such as spaces, with standard equivalents. It will also clean up filenames with UTF-8 or Latin-1 (or CP-1252) characters in them. | BSD |
| [dos2unix](https://waterlander.net/dos2unix) | Convert text files with DOS or Mac line breaks to Unix line breaks and vice versa. (`dos2unix`, `unix2dos`, `mac2unix`, `unix2mac`) | FreeBSD style |
| [fdupes](https://github.com/adrianlopezroche/fdupes#readme) | FDUPES is a program for identifying or deleting duplicate files residing within specified directories. | MIT |
| [file](http://www.darwinsys.com/file/) | The file command is "a file type guesser", that is, a command-line tool that tells you in words what kind of data a file contains. Unlike most GUI systems, command-line UNIX systems - with this program leading the charge - don't rely on filename extensions to tell you the type of a file, but look at the file's actual contents. This is, of course, more reliable, but requires a bit of I/O. | [license](https://github.com/file/file/blob/master/COPYING) |
| [fzf](https://github.com/junegunn/fzf#readme) | A command-line fuzzy finder. It's an interactive Unix filter for command-line that can be used with any list; files, command history, processes, hostnames, bookmarks, git commits, etc. | MIT |
| [iconv](https://linux.die.net/man/1/iconv) | Convert encoding of given files from one encoding to another. | GPL |
| [jdupes](http://www.jdupes.com/) | A powerful duplicate file finder and an enhanced fork of fdupes. | MIT |
| [jupp](http://www.mirbsd.org/jupp.htm) | Text editor jupp comes with the editor flavours known from joe, specifically, jmacs, joe, jpico, jstar, and rjoe. | GPLv1 |
| [less](https://www.gnu.org/software/less/) | GNU less is a program similar to more, but which allows backward movement in the file as well as forward movement. Also, less does not have to read the entire input file before starting, so with large input files it starts up faster than text editors like vi. Less uses termcap (or terminfo on some systems), so it can run on a variety of terminals. | GPLv3 |
| [lzip/plzip](http://lzip.nongnu.org/plzip.html) | Lzip is a lossless data compressor with a user interface similar to the one of gzip or bzip2. Lzip uses a simplified form of the 'Lempel-Ziv-Markov chain-Algorithm' (LZMA) stream format, chosen to maximize safety and interoperability. <br/> Plzip is a massively parallel (multi-threaded) implementation of lzip, fully compatible with lzip 1.4 or newer. | GPLv2 |
| [mc](https://midnight-commander.org/) | GNU Midnight Commander is a visual file manager. It's a feature rich full-screen text mode application that allows you to copy, move and delete files and whole directory trees, search for files and run commands in the subshell. Internal viewer and editor are included. | GPL |
| [mg](https://man.troglobit.com/man1/mg.1.html) | Micro (GNU) emacs-like text editor. <br/> `mg` is intended to be a small, fast, and portable editor for people who can't (or don't want to) run emacs for one reason or another, or are not familiar with the vi(1) editor. It is compatible with emacs because there shouldn't be any reason to learn more editor types than emacs or vi. | public domain |
| [micro](https://micro-editor.github.io/) | `micro` is a modern and intuitive terminal-based text editor. | MIT |
| [nano](https://www.nano-editor.org/) | nano is a text editor for Unix-like computing systems or operating environments using a command line interface. | GPLv2 |
| [nnn](https://github.com/jarun/nnn#readme) | nnn (n³) is a full-featured terminal file manager. | 2-Clause BSD |
| [patch](https://savannah.gnu.org/projects/patch/) | Patch takes a patch file containing a difference listing produced by the diff program and applies those differences to one or more original files, producing patched versions. | GPLv3+ |
| [pcre2grep](https://www.pcre.org/current/doc/html/pcre2grep.html) | `pcre2grep` searches files for text patterns using Perl-compatible regular expressions (PCRE2), supporting advanced features like lookaround and recursive patterns. | BSD |
| [pcre2test](https://www.pcre.org/current/doc/html/pcre2test.html) | `pcre2test` is used to test and experiment with Perl-compatible regular expressions using the PCRE2 libraries. | BSD |
| [pigz](https://zlib.net/pigz/) | A parallel implementation of `gzip` for modern multi-processor, multi-core machines. | [zlib-license](https://github.com/madler/pigz) | 
| [pixz](https://github.com/vasi/pixz#readme) | Pixz (pronounced pixie) is a parallel, indexing version of `xz`. | [2-Clause BSD](https://github.com/vasi/pixz?tab=BSD-2-Clause-1-ov-file#readme) |
| [rhash](http://rhash.sourceforge.net/) | RHash (Recursive Hasher) is a console utility for computing and verifying hash sums of files. It [supports](https://sourceforge.net/p/rhash/wiki/HashFunctions/) CRC32, CRC32C, MD4, MD5, SHA1, SHA256, SHA512, SHA3, AICH, ED2K, DC++ TTH, BitTorrent BTIH, Tiger, GOST R 34.11-94, GOST-CRYPTOPRO, RIPEMD-160, HAS-160, EDON-R, and Whirlpool. | MIT |
| [rmlint](https://rmlint.readthedocs.io/en/latest/) | rmlint finds space waste and other broken things on your filesystem and offers to remove it. | GPLv3 |
| [rnm](https://github.com/neurobin/rnm#readme) | `rnm` renames files/directories in bulk. Naming scheme (Name String) can be applied or regex replace can be performed to modify file names on the fly. It uses PCRE2 regex to provide search (and replace) functionality. | GPLv3 |
| [tree](https://oldmanprogrammer.net/source.php?dir=projects/tree) | Tree is a recursive directory listing command that produces a depth indented listing of files, which is colorized ala dircolors if the LS_COLORS environment variable is set and output is to tty. | GPLv2 |
| [xstow](https://github.com/majorkingleo/xstow#readme) | XStow is a replacement of GNU Stow written in C++. It supports all features of Stow with some extensions. <br/> GNU Stow is a symlink farm manager which takes distinct packages of software and/or data located in separate directories on the filesystem, and makes them appear to be installed in the same place. | GPLv2 |
| [zstd](https://facebook.github.io/zstd/) | Zstandard (`zstd`) is a fast compression algorithm, providing high compression ratios. It also offers a special mode for small data, called dictionary compression. | GPLv2 / BSD |

### Tools built with Rust

| Tool | Description | License |
|------|-------------|---------|
| [bat](https://github.com/sharkdp/bat#readme) | A cat(1) clone with syntax highlighting and Git integration. | MIT or Apache 2.0 |
| [eza](https://eza.rocks/) | A modern, maintained replacement for `ls`, written in rust. | MIT | 
| [fd](https://github.com/sharkdp/fd#readme) (fd-file) | `fd` is a program to find entries in your filesystem. It is a simple, fast and user-friendly alternative to `find`. While it does not aim to support all of find's powerful functionality, it provides sensible (opinionated) defaults for a majority of use cases. | Apache 2 / MIT |
| [lsd](https://github.com/lsd-rs/lsd#readme) (LSDeluxe) | The next gen `ls` command. | Apache 2.0 |
| [ripgrep](https://github.com/BurntSushi/ripgrep#readme) | `rg` is a line-oriented search tool that recursively searches your current directory for a regex pattern. | public domain / Unlicense |
| [sd](https://github.com/chmln/sd#readme) | Intuitive find & replace CLI (`sed` alternative) | MIT |

### Important note

Not all tools are available for all DiskStation and Router models.

## Related Packages

- [SynoCli Network Tools](synocli-net.md) - Network utilities
- [SynoCli Disk Tools](synocli-disk.md) - Disk utilities
- [SynoCli Misc Tools](synocli-misc.md) - Miscellaneous utilities
