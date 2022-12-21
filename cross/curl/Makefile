PKG_NAME = curl
PKG_VERS = 7.86.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://curl.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl
# optional features (see BUILD_CURL_WITH below)
OPTIONAL_DEPENDS = cross/libssh2 cross/gnutls cross/mbedtls

HOMEPAGE = https://curl.haxx.se
COMMENT  = Command line tool and library for transferring data with URLs.
LICENSE  = https://curl.haxx.se/docs/copyright.html

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --disable-static
CONFIGURE_ARGS += --enable-ipv6
CONFIGURE_ARGS += --with-openssl
CONFIGURE_ARGS += --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt
CONFIGURE_ARGS += --with-ca-path=/usr/share/ca-certificates/mozilla

ifneq ($(strip $(CURL_INCLUDE_EXECUTABLE)),1)
PLIST_TRANSFORM = sed -e '/bin:bin/d'
endif

ifneq ($(strip $(BUILD_CURL_WITH)),)
# optional dependencies to build curl with
ifeq ($(findstring libssh2,$(BUILD_CURL_WITH)),libssh2)
DEPENDS += cross/libssh2
CONFIGURE_ARGS += --with-libssh2
endif
ifeq ($(findstring gnutls,$(BUILD_CURL_WITH)),gnutls)
DEPENDS += cross/gnutls
CONFIGURE_ARGS += --with-gnutls
endif
ifeq ($(findstring mbedtls,$(BUILD_CURL_WITH)),mbedtls)
DEPENDS += cross/mbedtls
CONFIGURE_ARGS += --with-mbedtls
endif
endif

POST_INSTALL_TARGET = curl_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: curl_post_install
curl_post_install: $(EXTRA_POST_INSTALL)
	@$(MSG) Adjust prefix in curl-config
	sed -i.orig 's#prefix=/#prefix=$(INSTALL_DIR)/#' $(STAGING_INSTALL_PREFIX)/bin/curl-config
