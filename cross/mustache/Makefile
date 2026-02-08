PKG_NAME = Mustache
PKG_VERS = 4.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/kainjow/Mustache/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://github.com/kainjow/Mustache
COMMENT  = text templates for modern C++.
LICENSE  = BSL 1.0

GNU_CONFIGURE = 1
INSTALL_TARGET = mustache_install

include ../../mk/spksrc.cross-cmake.mk

.PHONY: mustache_install
mustache_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin $(STAGING_INSTALL_PREFIX)/include
	install $(WORK_DIR)/$(PKG_DIR)/build/mustache $(STAGING_INSTALL_PREFIX)/bin/mustache
	install $(WORK_DIR)/$(PKG_DIR)/mustache.hpp $(STAGING_INSTALL_PREFIX)/include/mustache.hpp
