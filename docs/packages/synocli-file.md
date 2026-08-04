---
title: SynoCli File Tools
description: Command-line file management utilities for Synology NAS
tags:
  - cli
  - file
  - tools
---

# SynoCli File Tools

The `synocli-file` package provides some file related tools to advanced Linux users:

| Tool | Description | License |
|------|-------------|---------|
| [less](https://www.gnu.org/software/less/) | GNU less is a program similar to more, but which allows backward movement in the file as well as forward movement. It does not have to read the entire input file before starting, so with large input files it starts up faster than text editors like vi. | GPLv3 |
| [tree](https://oldmanprogrammer.net/source.php?dir=projects/tree) | Tree is a recursive directory listing command that produces a depth indented listing of files, colorized ala dircolors if the `LS_COLORS` environment variable is set and output is to tty. | GPLv2 |
| [jdupes](https://codeberg.org/jbruchon/jdupes) | A powerful duplicate file finder and an enhanced fork of fdupes. | MIT |
| [fdupes](https://github.com/adrianlopezroche/fdupes) | Identifies or deletes duplicate files residing within specified directories. | MIT |
| [rhash](http://rhash.sourceforge.net/) | RHash (Recursive Hasher) is a console utility for computing and verifying hash sums of files. It supports CRC32, MD4, MD5, SHA1, SHA256, SHA512, SHA3, Tiger, BitTorrent BTIH, ED2K, and more. | MIT |
| [mc](https://midnight-commander.org/) | GNU Midnight Commander is a visual file manager. It allows you to copy, move and delete files and whole directory trees, search for files and run commands in the subshell. Internal viewer and editor are included. | GNU GPL |
| [nano](https://www.nano-editor.org/) | nano is a text editor for Unix-like computing systems or operating environments using a command line interface. | GPLv2 |
| [micro](https://micro-editor.github.io/) | micro is a modern and intuitive terminal-based text editor. | MIT |
| [rnm](https://neurobin.org/projects/softwares/unix/rnm/) | rnm renames files/directories in bulk using a naming scheme or regex replace, powered by PCRE2. | GPLv3 |
| [file](http://www.darwinsys.com/file/) | The file command is a file type guesser, that is, a command-line tool that tells you in words what kind of data a file contains. | [license](https://github.com/file/file/blob/master/COPYING) |
| [fzf (fuzzy finder)](https://github.com/junegunn/fzf) | A command-line fuzzy finder and interactive Unix filter that can be used with any list; files, command history, processes, hostnames, bookmarks, git commits, etc. | MIT |
| [detox](http://detox.sourceforge.net/) | Detox cleans up filenames by replacing difficult to work with characters, such as spaces, with standard equivalents, including UTF-8 or Latin-1 (or CP-1252) characters. | BSD |
| [rmlint](https://rmlint.readthedocs.io/en/latest/) | rmlint finds space waste and other broken things on your filesystem and offers to remove it. | GPLv3 |
| [ripgrep (`rg`)](https://github.com/BurntSushi/ripgrep) | `rg` is a line-oriented search tool that recursively searches your current directory for a regex pattern. | public domain/Unlicense |
| [zstd](https://facebook.github.io/zstd/) | Zstandard (`zstd`) is a fast compression algorithm, providing high compression ratios. It also offers a special mode for small data, called dictionary compression. | GPLv2/BSD |
| [lzip / plzip](http://lzip.nongnu.org/plzip.html) | Lzip is a lossless data compressor with a user interface similar to the one of gzip or bzip2. Plzip is a massively parallel (multi-threaded) implementation of lzip, fully compatible with lzip 1.4 or newer. | GPLv2 |
| [pixz](https://github.com/vasi/pixz) | Pixz (pronounced pixie) is a parallel, indexing version of `xz`. | 2-Clause BSD |
| [pigz](https://zlib.net/pigz/) | A parallel implementation of `gzip` for modern multi-processor, multi-core machines. | zlib |
| [fd (`fd-file`)](https://github.com/sharkdp/fd) | fd is a simple, fast and user-friendly alternative to `find`. While it does not aim to support all of find's functionality, it provides sensible defaults for a majority of use cases. | Apache 2/MIT |
| [mg - Micro (GNU) emacs-like text editor](https://man.troglobit.com/man1/mg.1.html) | `mg` is a small, fast, and portable editor for people who can't (or don't want to) run emacs, or are not familiar with the vi(1) editor. It is compatible with emacs. | public domain |
| [bat](https://github.com/sharkdp/bat) | A cat(1) clone with wings. | MIT or Apache 2.0 |
| [eza](https://eza.rocks/) | A modern replacement for `ls` (replacement for the archived exa). | MIT |
| [lsd (`LSDeluxe`)](https://github.com/lsd-rs/lsd/) | The next gen `ls` command. | Apache 2.0 |
| [jupp](http://www.mirbsd.org/jupp.htm) | Text editor jupp comes with the editor flavours known from joe, specifically, jmacs, joe, jpico, jstar, and rjoe. | GPLv1 |
| [nnn](https://github.com/jarun/nnn) | nnn (n³) is a full-featured terminal file manager. | 2-clause BSD |
| [iconv](https://linux.die.net/man/1/iconv) | Convert encoding of given files from one encoding to another. | GPL |
| [dos2unix](https://waterlander.net/dos2unix) | Convert text files with DOS or Mac line breaks to Unix line breaks and vice versa. | FreeBSD style |
| [xstow](https://github.com/majorkingleo/xstow#readme) | XStow is a replacement of GNU Stow written in C++. It supports all features of Stow with some extensions. | GPLv2 |
| [patch](https://savannah.gnu.org/projects/patch/) | Patch takes a patch file containing a difference listing produced by the diff program and applies those differences to one or more original files, producing patched versions. | GPLv3+ |
| [pcre2grep / pcre2test](https://www.pcre.org/) | PCRE2 grep and test tools from the PCRE2 regular expression library. | BSD |
| [sd](https://github.com/chmln/sd#readme) | An intuitive find and replace CLI (sed alternative). | MIT |

## Related Packages

- [SynoCli Network Tools](synocli-net.md) - Network utilities
- [SynoCli Disk Tools](synocli-disk.md) - Disk utilities
- [SynoCli Misc Tools](synocli-misc.md) - Miscellaneous utilities
