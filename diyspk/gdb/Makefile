SPK_NAME = gdb
SPK_REV = 1
SPK_ICON = src/gdb.png

MAINTAINER = th0ma7
DESCRIPTION = The GNU Debugger (GDB) is a portable debugger that runs on many Unix-like systems and works for many programming languages, including Ada, C, C++, Objective-C, Free Pascal, Fortran, Go and partially others.
STARTABLE = no

HOMEPAGE = https://www.sourceware.org/gdb/
LICENSE  = GPLv2

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS = cross/gdb-legacy
SPK_VERS = 7.12.1
else
DEPENDS = cross/gdb
SPK_VERS = 12.1
endif

SPK_COMMANDS  = bin/gcore
SPK_COMMANDS += bin/gdb
SPK_COMMANDS += bin/gdb-add-index
SPK_COMMANDS += bin/gdbserver
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
SPK_COMMANDS += bin/run
endif

include ../../mk/spksrc.spk.mk
