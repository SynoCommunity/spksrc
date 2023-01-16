SPK_NAME = synocli-misc
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synocli-misc.png

DEPENDS = cross/bc cross/moreutils cross/misc-util-linux

MAINTAINER = SynoCommunity
DISPLAY_NAME = SynoCli misc. Tools

DESCRIPTION = "SynoCli misc. Tools provide a set of miscellaneous small command-line utilities: bc, errno, ifdata, ifne, isutf8, lckdo, mispipe, parallel, pee, sponge, cal, col, colcrt, colrm, column, hexdump, lscpu, lsipc, lsirq, rev, wall, whereis."
STARTABLE = no
CHANGELOG = "Initial package release."

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

# util-linux:
SPK_COMMANDS += bin/cal
SPK_COMMANDS += bin/col
SPK_COMMANDS += bin/colcrt
SPK_COMMANDS += bin/colrm
SPK_COMMANDS += bin/column
SPK_COMMANDS += bin/hexdump
SPK_COMMANDS += bin/lscpu
SPK_COMMANDS += bin/lsipc
SPK_COMMANDS += bin/lsirq
SPK_COMMANDS += bin/rev
SPK_COMMANDS += bin/wall
SPK_COMMANDS += bin/whereis


include ../../mk/spksrc.spk.mk
