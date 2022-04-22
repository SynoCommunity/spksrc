SPK_NAME = gdb
SPK_VERS = 11.2
SPK_REV = 1
SPK_ICON = src/gdb.png
CHANGELOG = "1. Initial release of gdb 11.2 including binutils 2.38"

DEPENDS = cross/$(SPK_NAME) cross/binutils

MAINTAINER = th0ma7
DESCRIPTION = The GNU Debugger (GDB) is a portable debugger that runs on many Unix-like systems and works for many programming languages, including Ada, C, C++, Objective-C, Free Pascal, Fortran, Go and partially others.
DISPLAY_NAME = gdb
STARTABLE = no

HOMEPAGE = https://www.sourceware.org/gdb/
LICENSE  = GPLv2

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS)

include ../../mk/spksrc.spk.mk
