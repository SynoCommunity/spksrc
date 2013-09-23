PKG_NAME = freetype
PKG_VERS = 2.4.9
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)2/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://www.freetype.org
COMMENT  = A Free, High-Quality, and Portable Font Engine
LICENSE  = BSD/GPL2


GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-python
CONFIGURE_ARGS += --libdir=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib


include ../../mk/spksrc.cross-cc.mk
