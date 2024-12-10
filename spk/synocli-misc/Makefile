SPK_NAME = synocli-misc
SPK_VERS = 1.2
SPK_REV = 6
SPK_ICON = src/synocli-misc.png

DEPENDS  = cross/bc
DEPENDS += cross/moreutils
DEPENDS += cross/misc-util-linux
DEPENDS += cross/uhubctl
DEPENDS += cross/expect

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli misc. Tools

DESCRIPTION = "SynoCli misc. Tools provide a set of miscellaneous small command-line utilities: bc, errno, expect, ifdata, ifne, isutf8, lckdo, mispipe, parallel, pee, sponge, ts, cal, col, colcrt, colrm, column, hardlink, hexdump, lsblk, lscpu, lsipc, lsirq, rev, wall, whereis, zramctl, uhubctl."
STARTABLE = no
CHANGELOG = "1. Add ts command of moreutils."

HOMEPAGE = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SynoCliMisc
LICENSE  = Each tool is licensed under it's respective license.

# gnu:
SPK_COMMANDS = bin/bc bin/dc

# moreutils:
SPK_COMMANDS += bin/errno
SPK_COMMANDS += bin/ifdata
SPK_COMMANDS += bin/ifne
SPK_COMMANDS += bin/isutf8
SPK_COMMANDS += bin/lckdo
SPK_COMMANDS += bin/mispipe
SPK_COMMANDS += bin/parallel
SPK_COMMANDS += bin/pee
SPK_COMMANDS += bin/sponge
# ts is a perl script
SPK_COMMANDS += bin/ts

# util-linux:
SPK_COMMANDS += bin/cal
SPK_COMMANDS += bin/col
SPK_COMMANDS += bin/colcrt
SPK_COMMANDS += bin/colrm
SPK_COMMANDS += bin/column
SPK_COMMANDS += bin/hardlink
SPK_COMMANDS += bin/hexdump
# lsblk is not included in OLD_PPC_ARCHS
SPK_COMMANDS += bin/lsblk
SPK_COMMANDS += bin/lscpu
SPK_COMMANDS += bin/lsipc
SPK_COMMANDS += bin/lsirq
SPK_COMMANDS += bin/rev
SPK_COMMANDS += bin/wall
SPK_COMMANDS += bin/whereis
SPK_COMMANDS += bin/zramctl

# uhubctl
SPK_COMMANDS += bin/uhubctl

# expect
SPK_COMMANDS += bin/expect

include ../../mk/spksrc.spk.mk
