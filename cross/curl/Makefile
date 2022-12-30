PKG_NAME = curl
PKG_VERS = 7.87.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://curl.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl
# optional features (see BUILD_CURL_WITH below)
OPTIONAL_DEPENDS = cross/libssh2 cross/gnutls cross/mbedtls cross/libidn2 cross/libpsl cross/nghttp2 cross/gsasl cross/gss cross/openldap

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

# optional dependencies to build curl with
ifneq ($(strip $(BUILD_CURL_WITH)),)

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

ifeq ($(findstring libidn2,$(BUILD_CURL_WITH)),libidn2)
DEPENDS += cross/libidn2
CONFIGURE_ARGS += --with-libidn2
endif

ifeq ($(findstring libpsl,$(BUILD_CURL_WITH)),libpsl)
DEPENDS += cross/libpsl
CONFIGURE_ARGS += --with-libpsl
endif

ifeq ($(findstring nghttp2,$(BUILD_CURL_WITH)),nghttp2)
DEPENDS += cross/nghttp2
CONFIGURE_ARGS += --with-nghttp2
endif

ifeq ($(findstring gsasl,$(BUILD_CURL_WITH)),gsasl)
DEPENDS += cross/gsasl
endif

ifeq ($(findstring gss,$(BUILD_CURL_WITH)),gss)
DEPENDS += cross/gss
CONFIGURE_ARGS += --with-gssapi=$(STAGING_INSTALL_PREFIX)
endif

ifeq ($(findstring ldap,$(BUILD_CURL_WITH)),ldap)
DEPENDS += cross/openldap
CONFIGURE_ARGS += --enable-ldap
CONFIGURE_ARGS += --enable-ldaps
endif

ifeq ($(findstring websockets,$(BUILD_CURL_WITH)),websockets)
CONFIGURE_ARGS += --enable-websockets
$(warning  "Websockets enabled but marked EXPERIMENTAL. Use with caution!")
endif

endif

POST_INSTALL_TARGET = curl_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: curl_post_install
curl_post_install: $(EXTRA_POST_INSTALL)
	@$(MSG) Adjust prefix in curl-config
	sed -i.orig 's#prefix=/#prefix=$(INSTALL_DIR)/#' $(STAGING_INSTALL_PREFIX)/bin/curl-config
