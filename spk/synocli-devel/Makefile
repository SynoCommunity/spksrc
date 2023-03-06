SPK_NAME = synocli-devel
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/synocli-develop.png
CHANGELOG = "1. Initial release of synocli-devel"

MAINTAINER = SynoCommunity
DESCRIPTION = SynoCli Development Tools provides a set of command-line utilities for system development and debugging: binutils 2.39$(OPTIONAL_DESC).
DISPLAY_NAME = SynoCli Development Tools
STARTABLE = no

HOMEPAGE = https://www.sourceware.org/gdb/
LICENSE  = GPLv2

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

include ../../mk/spksrc.archs.mk

DEPENDS  = cross/binutils
DEPENDS += cross/gdb
DEPENDS += cross/llvm

SPK_COMMANDS += bin/addr2line
SPK_COMMANDS += bin/ar
SPK_COMMANDS += bin/as
SPK_COMMANDS += bin/c++filt
SPK_COMMANDS += bin/dwp
SPK_COMMANDS += bin/elfedit
ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
SPK_COMMANDS += bin/gp-archive
SPK_COMMANDS += bin/gp-collect-app
SPK_COMMANDS += bin/gp-display-html
SPK_COMMANDS += bin/gp-display-src
SPK_COMMANDS += bin/gp-display-text
SPK_COMMANDS += bin/gprofng
endif
SPK_COMMANDS += bin/gprof
SPK_COMMANDS += bin/ld
SPK_COMMANDS += bin/ld.bfd
SPK_COMMANDS += bin/ld.gold
SPK_COMMANDS += bin/nm
SPK_COMMANDS += bin/objcopy
SPK_COMMANDS += bin/objdump
SPK_COMMANDS += bin/ranlib
SPK_COMMANDS += bin/readelf
SPK_COMMANDS += bin/size
SPK_COMMANDS += bin/strings
SPK_COMMANDS += bin/strip

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
OPTIONAL_DESC += ", gdb 7.12.1"
else
OPTIONAL_DESC += ", gdb 12.1"
endif

SPK_COMMANDS += bin/gcore
SPK_COMMANDS += bin/gdb
SPK_COMMANDS += bin/gdb-add-index
SPK_COMMANDS += bin/gdbserver
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
SPK_COMMANDS += bin/run
endif

include ../../mk/spksrc.spk.mk
