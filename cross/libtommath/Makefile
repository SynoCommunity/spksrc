PKG_NAME = libtommath
PKG_VERS = 1.2.0
PKG_EXT = zip
PKG_DIST_NAME = ltm-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libtom/libtommath/releases/download/v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# libtommath builds using libtool
DEPENDS = cross/libtool

# archs with too old c++ compiler (c++ 11 is required)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.libtom.net/LibTomMath/
COMMENT = LibTomMath is a free open source portable number theoretic multiple-precision integer library written entirely in C. (phew!).
LICENSE = The LibTom license
MAINTAINER = vitkabele

CONFIGURE_TARGET = nop

# Path to the libtool installed in the cross/libtool DEPENDS target
LIBTOOL_BIN = $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/libtool

# We must use the cross-built libtool, because it uses its own linker
MAKEFILE_FLAGS = -f makefile.shared LIBTOOL=$(LIBTOOL_BIN)

COMPILE_MAKE_OPTIONS = $(MAKEFILE_FLAGS)

POST_INSTALL_TARGET = libtommath_post_install

include ../../mk/spksrc.cross-cc.mk

# The framework supplies only prefix=, but our makefile wants PREFIX=
INSTALL_MAKE_OPTIONS += $(MAKEFILE_FLAGS) PREFIX=$(INSTALL_PREFIX)

.PHONY: libtommath_post_install
libtommath_post_install:
	$(RUN) $(LIBTOOL_BIN) --finish $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/
