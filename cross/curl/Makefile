PKG_NAME = curl
PKG_VERS = 7.84.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://curl.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = https://curl.haxx.se
COMMENT  = Command line tool and library for transferring data with URLs
LICENSE  = https://curl.haxx.se/docs/copyright.html

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --enable-ipv6
CONFIGURE_ARGS += --with-openssl
CONFIGURE_ARGS += --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt

ifneq ($(strip $(CURL_INCLUDE_EXECUTABLE)),1)
PLIST_TRANSFORM = sed -e '/bin:bin/d'
endif

POST_INSTALL_TARGET = curl_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: curl_post_install
curl_post_install: $(EXTRA_POST_INSTALL)
	sed -i.orig 's#prefix=/#prefix=$(INSTALL_DIR)/#' $(STAGING_INSTALL_PREFIX)/bin/curl-config
