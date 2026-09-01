PKG_NAME = curl
PKG_VERS = 8.21.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://curl.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl3 cross/c-ares
# optional features (see BUILD_CURL_WITH below)
OPTIONAL_DEPENDS  = cross/libssh2
OPTIONAL_DEPENDS += cross/gnutls
OPTIONAL_DEPENDS += cross/mbedtls
OPTIONAL_DEPENDS += cross/libidn2
OPTIONAL_DEPENDS += cross/libpsl
OPTIONAL_DEPENDS += cross/nghttp2
OPTIONAL_DEPENDS += cross/nghttp3
OPTIONAL_DEPENDS += cross/ngtcp2
OPTIONAL_DEPENDS += cross/gsasl
OPTIONAL_DEPENDS += cross/gss
OPTIONAL_DEPENDS += cross/zstd
OPTIONAL_DEPENDS += cross/brotli
OPTIONAL_DEPENDS += cross/openldap

HOMEPAGE = https://curl.haxx.se
COMMENT  = Command line tool and library for transferring data with URLs.
LICENSE  = https://curl.haxx.se/docs/copyright.html

CONFIGURE_ARGS  = -DBUILD_STATIC_LIBS=OFF
CONFIGURE_ARGS += -DENABLE_IPV6=ON
CONFIGURE_ARGS += -DENABLE_ARES=ON
CONFIGURE_ARGS += -DCURL_USE_OPENSSL=ON
CONFIGURE_ARGS += -DCURL_ZLIB=ON
CONFIGURE_ARGS += -DCURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
CONFIGURE_ARGS += -DCURL_CA_PATH=/usr/share/ca-certificates/mozilla

# Do not fail on warnings when built in debug mode
ifeq ($(GCC_DEBUG_INFO),1)
CONFIGURE_ARGS += -DCURL_CODE_COVERAGE=OFF
CONFIGURE_ARGS += -DENABLE_DEBUG=OFF
CONFIGURE_ARGS += -DCURL_WERROR=OFF
endif

ifneq ($(strip $(CURL_INCLUDE_EXECUTABLE)),1)
PLIST_TRANSFORM = sed -e '/bin:bin/d'
endif

include ../../mk/spksrc.common.mk

# glibc gained EFD_CLOEXEC/EFD_NONBLOCK in 2.9 with eventfd2; 2.8 has the function and the
# header but not the flags, and cmake only probes the function (check_function_exists).
# Pre-defining the cache variable skips that probe, so curl falls back to pipe.
ifeq ($(call version_lt,$(TC_GLIBC),2.9),1)
CONFIGURE_ARGS += -DHAVE_EVENTFD=OFF
endif

ifneq ($(ARCH),)
ifeq ($(call version_ge, $(TC_GCC), 4.9),1)
HTTP3_SUPPORTED = 1
else
HTTP3_SUPPORTED = 0
endif
endif

#
# optional dependencies to build curl with optional features
#
# Unlike autotools, cmake defaults several of these to ON and then looks for the library.
# Each one is therefore stated in both directions -- never left to the default.
#

ifeq ($(findstring libssh2,$(BUILD_CURL_WITH)),libssh2)
DEPENDS += cross/libssh2
CONFIGURE_ARGS += -DCURL_USE_LIBSSH2=ON
else
CONFIGURE_ARGS += -DCURL_USE_LIBSSH2=OFF
endif

ifeq ($(findstring gnutls,$(BUILD_CURL_WITH)),gnutls)
DEPENDS += cross/gnutls
CONFIGURE_ARGS += -DCURL_USE_GNUTLS=ON
endif

ifeq ($(findstring mbedtls,$(BUILD_CURL_WITH)),mbedtls)
DEPENDS += cross/mbedtls
CONFIGURE_ARGS += -DCURL_USE_MBEDTLS=ON
endif

ifeq ($(findstring libidn2,$(BUILD_CURL_WITH)),libidn2)
DEPENDS += cross/libidn2
CONFIGURE_ARGS += -DUSE_LIBIDN2=ON
else
CONFIGURE_ARGS += -DUSE_LIBIDN2=OFF
endif

ifeq ($(findstring libpsl,$(BUILD_CURL_WITH)),libpsl)
DEPENDS += cross/libpsl
CONFIGURE_ARGS += -DCURL_USE_LIBPSL=ON
else
CONFIGURE_ARGS += -DCURL_USE_LIBPSL=OFF
endif

ifeq ($(findstring nghttp2,$(BUILD_CURL_WITH)),nghttp2)
DEPENDS += cross/nghttp2
CONFIGURE_ARGS += -DUSE_NGHTTP2=ON
else
CONFIGURE_ARGS += -DUSE_NGHTTP2=OFF
endif

ifeq ($(findstring nghttp3,$(BUILD_CURL_WITH)),nghttp3)
ifeq ($(HTTP3_SUPPORTED),1)
DEPENDS += cross/ngtcp2 cross/nghttp3
# USE_NGHTTP3 is turned on by curl itself once USE_NGTCP2 is set.
CONFIGURE_ARGS += -DUSE_NGTCP2=ON
CONFIGURE_ARGS += -DCURL_WITH_MULTI_SSL=OFF
else ifneq ($(ARCH),)
$(warning "WARNING: HTTP3 is not supported for ARCH=$(ARCH)")
endif
endif

ifeq ($(findstring gsasl,$(BUILD_CURL_WITH)),gsasl)
DEPENDS += cross/gsasl
CONFIGURE_ARGS += -DCURL_USE_GSASL=ON
endif

ifeq ($(findstring gss,$(BUILD_CURL_WITH)),gss)
DEPENDS += cross/gss
CONFIGURE_ARGS += -DCURL_USE_GSSAPI=ON
CONFIGURE_ARGS += -DGSS_ROOT_DIR=$(STAGING_INSTALL_PREFIX)
endif

ifeq ($(findstring zstd,$(BUILD_CURL_WITH)),zstd)
DEPENDS += cross/zstd
CONFIGURE_ARGS += -DCURL_ZSTD=ON
else
CONFIGURE_ARGS += -DCURL_ZSTD=OFF
endif

ifeq ($(findstring brotli,$(BUILD_CURL_WITH)),brotli)
DEPENDS += cross/brotli
CONFIGURE_ARGS += -DCURL_BROTLI=ON
else
CONFIGURE_ARGS += -DCURL_BROTLI=OFF
endif

ifeq ($(findstring ldap,$(BUILD_CURL_WITH)),ldap)
DEPENDS += cross/openldap
CONFIGURE_ARGS += -DCURL_DISABLE_LDAP=OFF
CONFIGURE_ARGS += -DCURL_DISABLE_LDAPS=OFF
else
CONFIGURE_ARGS += -DCURL_DISABLE_LDAP=ON
CONFIGURE_ARGS += -DCURL_DISABLE_LDAPS=ON
endif

ifeq ($(findstring websockets,$(BUILD_CURL_WITH)),websockets)
CONFIGURE_ARGS += -DCURL_DISABLE_WEBSOCKETS=OFF
$(warning  "WARNING: Websockets enabled but marked EXPERIMENTAL. Use with caution!")
else
CONFIGURE_ARGS += -DCURL_DISABLE_WEBSOCKETS=ON
endif

POST_INSTALL_TARGET = curl_post_install

include ../../mk/spksrc.cross-cmake.mk

.PHONY: curl_post_install
curl_post_install: $(EXTRA_POST_INSTALL)
	@$(MSG) Adjust prefix in curl-config
	sed -i.orig 's#prefix=/#prefix=$(INSTALL_DIR)/#' $(STAGING_INSTALL_PREFIX)/bin/curl-config
