PKG_NAME = binutils
PKG_VERS = 2.40
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/binutils
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

# Fails to build on i686 and does not build on other 32-bit archs
ifneq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-gprofng
PLIST_TRANSFORM = sed -e '/bin\/gprofng/d' -e '/bin\/gp\-/d' -e '/lib\/gprofng/d'
endif

# Avoid conflicts with gdb
CONFIGURE_ARGS += --includedir=$(INSTALL_PREFIX)/include/binutils

include ../../mk/spksrc.cross-cc.mk
