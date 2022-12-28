PKG_NAME = binutils
PKG_VERS = 2.39
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/binutils/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/gmp cross/mpfr

HOMEPAGE = https://www.gnu.org/software/binutils/
COMMENT  = GNU Binutils
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.archs.mk

CONFIGURE_ARGS += --enable-host-shared
CONFIGURE_ARGS += --with-system-zlib
CONFIGURE_ARGS += --enable-gold=yes
# Fails to build on i686
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-gprofng=no
endif
# Otherwise conflicts with gdb
CONFIGURE_ARGS += --includedir=$(INSTALL_PREFIX)/include/binutils

include ../../mk/spksrc.cross-cc.mk
