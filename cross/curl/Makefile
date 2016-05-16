PKG_NAME = curl
PKG_VERS = 7.47.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://curl.haxx.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = http://curl.haxx.se
COMMENT  = Compression Library
LICENSE  = http://curl.haxx.se/docs/copyright.html

GNU_CONFIGURE = 1

CONFIGURE_TARGET = myConfigure
POST_INSTALL_TARGET = myPostInstall

CONFIGURE_ARGS = --enable-ipv6 --with-ca-bundle=$(INSTALL_PREFIX)/cert.pem

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) ./configure $(REAL_CONFIGURE_ARGS) CFLAGS=

.PHONY: myPostInstall
myPostInstall:
	sed -i.orig 's#prefix=/#prefix=$(INSTALL_DIR)/#' $(STAGING_INSTALL_PREFIX)/bin/curl-config
	$(WORK_DIR)/$(PKG_DIR)/lib/mk-ca-bundle.pl -u $(STAGING_INSTALL_PREFIX)/cert.pem
