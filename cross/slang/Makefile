PKG_NAME = slang
PKG_VERS = 2.2.4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.jedsoft.org/releases/$(PKG_NAME)/old
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/pcre

HOMEPAGE = https://www.jedsoft.org/slang/
COMMENT  = Library for creating multi-platform software.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-z=$(INSTALL_DIR)/$(INSTALL_PREFIX)
CONFIGURE_ARGS += --with-pcre=$(INSTALL_DIR)/$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
