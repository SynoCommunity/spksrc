PKG_NAME = gdb-main

HOMEPAGE = https://www.gnu.org/software/gdb/
COMMENT  = The GNU Project Debugger
LICENSE  = GPLv2/LGPLv2

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

OPTIONAL_DEPENDS  = cross/gdb-latest
OPTIONAL_DEPENDS += cross/gdb-7.12

include ../../mk/spksrc.install-resources.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
DEPENDS += cross/gdb-7.12
else
DEPENDS += cross/gdb-latest
endif
