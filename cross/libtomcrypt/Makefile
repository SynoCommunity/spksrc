PKG_NAME = libtomcrypt
PKG_VERS = 1.18.2
PKG_EXT = zip
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libtom/libtomcrypt/archive/refs/tags/
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# libtomcrypt builds using libtool
DEPENDS = cross/libtool

# archs with too old c++ compiler (c++ 11 is required)
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.libtom.net/LibTomCrypt/
COMMENT = LibTomCrypt is a fairly comprehensive, modular and portable cryptographic toolkit.
LICENSE = The LibTom license
MAINTAINER = vitkabele

CONFIGURE_TARGET = nop

# Path to the libtool installed in the cross/libtool DEPENDS target
LIBTOOL_BIN = $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/libtool

# We must use the cross-built libtool, because it uses its own linker
MAKEFILE_FLAGS = -f makefile.shared LIBTOOL=$(LIBTOOL_BIN)

COMPILE_MAKE_OPTIONS = $(MAKEFILE_FLAGS)

POST_INSTALL_TARGET = libtomcrypt_post_install

include ../../mk/spksrc.cross-cc.mk

# The framework supplies only prefix=, but our makefile wants PREFIX=
INSTALL_MAKE_OPTIONS += $(MAKEFILE_FLAGS) PREFIX=$(INSTALL_PREFIX)

.PHONY: libtomcrypt_post_install
libtomcrypt_post_install:
	$(RUN) $(LIBTOOL_BIN) --finish $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/
