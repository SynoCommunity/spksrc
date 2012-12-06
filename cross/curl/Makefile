PKG_NAME = curl
PKG_VERS = 7.28.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://curl.haxx.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = http://curl.haxx.se/
COMMENT  = Compression Library
LICENSE  =

GNU_CONFIGURE = 1

POST_INSTALL_TARGET = correct-curl-config

include ../../mk/spksrc.cross-cc.mk

.PHONY: correct-curl-config
correct-curl-config:
	sed -i.orig 's#prefix=/#prefix=$(INSTALL_DIR)/#' $(STAGING_INSTALL_PREFIX)/bin/curl-config
