PKG_NAME = umurmur
PKG_VERS = 0.3.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/umurmur/umurmur/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libconfig cross/protobuf-c cross/mbedtls

HOMEPAGE = https://github.com/umurmur/umurmur
COMMENT  = uMurmur is a minimalistic Mumble server.
LICENSE  = 3-clause BSD

# 'cmake install' does not handle INSTALL_PREFIX/DESTDIR as expected.
INSTALL_TARGET = umurmur_install

CMAKE_ARGS = -DSSL=mbedtls
# let cmake find include and library of mbedtls
CMAKE_ARGS += -DCMAKE_STAGING_PREFIX=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cmake.mk

.PHONY: umurmur_install
umurmur_install:
	install -d -m 755 $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(CMAKE_BUILD_DIR)/bin/umurmurd $(STAGING_INSTALL_PREFIX)/bin
