PKG_NAME = glibc-main

HOMEPAGE = https://www.gnu.org/software/libc/
COMMENT  = The GNU C Library (glibc)
LICENSE  = GPLv2/LGPLv2

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

OPTIONAL_DEPENDS  = cross/glibc-latest
OPTIONAL_DEPENDS += cross/glibc-2.28

include ../../mk/spksrc.install-resources.mk

ifeq ($(call version_ge, $(TC_GCC), 5.1),1)
DEPENDS = cross/glibc-latest
else
DEPENDS = cross/glibc-2.28
endif
