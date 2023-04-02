PKG_NAME = llvm-main

HOMEPAGE = https://www.gnu.org/software/gdb/
COMMENT  = The GNU Project Debugger
LICENSE  = GPLv2/LGPLv2

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

OPTIONAL_DEPENDS  = cross/llvm-latest
OPTIONAL_DEPENDS += cross/llvm-9.0

include ../../mk/spksrc.install-resources.mk

ifeq ($(call version_ge, $(TC_GCC), 5.1),1)
DEPENDS = cross/llvm-latest
else
DEPENDS = cross/llvm-9.0
endif
