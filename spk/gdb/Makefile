SPK_NAME = synocli-devel
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/gdb.png
CHANGELOG = "1. Initial release of synocli-devel"

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = th0ma7
DESCRIPTION = The GNU Debugger (GDB) is a portable debugger that runs on many Unix-like systems and works for many programming languages, including Ada, C, C++, Objective-C, Free Pascal, Fortran, Go and partially others.
DISPLAY_NAME = synocli-devel
STARTABLE = no

HOMEPAGE = https://www.sourceware.org/gdb/
LICENSE  = GPLv2

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

# ******* Fails to build on PPC *******
#ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS))),$(ARCH))
DEPENDS += cross/gdb-legacy
CHANGELOG += "<br/>2. Include gdb 7.12.1"
else
DEPENDS += cross/gdb
CHANGELOG += "<br/>2. Include gdb 12.1"
endif

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)),$(ARCH))
DEPENDS += cross/binutils-legacy
CHANGELOG += "<br/>3. Include binutils 2.38"
else
DEPENDS += cross/binutils
CHANGELOG += "<br/>3. Include binutils 2.39"
endif

include ../../mk/spksrc.spk.mk
