PKG_NAME = libsigc++-main

HOMEPAGE = http://libsigc.sourceforge.net/
COMMENT  = libsigc++ implements a typesafe callback system for standard C++
LICENSE  = LGPL

# support for c++11/c++17 language features is required
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(PPC_ARCHS) $(OLD_PPC_ARCHS)

DOWNLOAD_TARGET = nop
CHECKSUM_TARGET = nop
EXTRACT_TARGET = nop
CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = nop

OPTIONAL_DEPENDS  = cross/libsigc++-latest
OPTIONAL_DEPENDS += cross/libsigc++-2.12

include ../../mk/spksrc.install-resources.mk

ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS = cross/libsigc++-latest
else
DEPENDS = cross/libsigc++-2.12
endif
