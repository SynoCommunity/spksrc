SPK_NAME = synocli-devel
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/gdb.png
CHANGELOG = "1. Initial release of synocli-devel"

#DEPENDS = cross/$(SPK_NAME)

MAINTAINER = th0ma7
DESCRIPTION = SynoCli Development Tools provides a set of command-line utilities for system development and debugging: $(OPTIONAL_DESC).
DISPLAY_NAME = SynoCli Development Tools
STARTABLE = no

HOMEPAGE = https://www.sourceware.org/gdb/
LICENSE  = GPLv2

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

include ../../mk/spksrc.archs.mk

# ******* Fails to build on PPC *******
#ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS += cross/gdb-legacy
OPTIONAL_DESC += "gdb 7.12.1"
else
DEPENDS += cross/gdb
OPTIONAL_DESC += "gdb 12.1"
endif

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)),$(ARCH))
DEPENDS += cross/binutils-legacy
OPTIONAL_DESC += ", binutils 2.38"
else
DEPENDS += cross/binutils
OPTIONAL_DESC += ", binutils 2.39"
endif

include ../../mk/spksrc.spk.mk
