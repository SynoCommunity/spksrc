PKG_NAME = jdupes
PKG_VERS = 1.28.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://codeberg.org/jbruchon/jdupes/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)

DEPENDS = cross/libjodycode

HOMEPAGE = https://www.jdupes.com/
COMMENT  = A powerful duplicate file finder and an enhanced fork of fdupes.
LICENSE  = MIT

CONFIGURE_TARGET = nop
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) PREFIX=$(INSTALL_PREFIX)

ADDITIONAL_CFLAGS = -DENABLE_DEDUPE

include ../../mk/spksrc.cross-cc.mk
