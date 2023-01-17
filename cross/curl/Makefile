PKG_NAME = curl
PKG_VERS = 7.62.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://curl.haxx.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = http://curl.haxx.se
COMMENT  = Command line tool and library for transferring data with URLs
LICENSE  = http://curl.haxx.se/docs/copyright.html

GNU_CONFIGURE = 1

CONFIGURE_TARGET = curl_configure
POST_INSTALL_TARGET = curl_post_install

CONFIGURE_ARGS = --enable-ipv6 --with-ca-bundle=$(INSTALL_PREFIX)/cert.pem

include ../../mk/spksrc.cross-cc.mk

.PHONY: curl_configure
curl_configure:
	$(RUN) ./configure $(REAL_CONFIGURE_ARGS) CFLAGS=

.PHONY: curl_post_install
curl_post_install:
	sed -i.orig 's#prefix=/#prefix=$(INSTALL_DIR)/#' $(STAGING_INSTALL_PREFIX)/bin/curl-config
	$(WORK_DIR)/$(PKG_DIR)/lib/mk-ca-bundle.pl -u $(STAGING_INSTALL_PREFIX)/cert.pem
