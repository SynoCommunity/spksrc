PKG_NAME = curl
PKG_VERS = 7.70.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://curl.haxx.se/download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = http://curl.haxx.se
COMMENT  = Command line tool and library for transferring data with URLs
LICENSE  = https://curl.haxx.se/docs/copyright.html

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-ipv6

POST_INSTALL_TARGET = curl_post_install

# this is a first attempt to avoid generation of ca-bundle for
# packages that don't use it.
# 
# definitive attempt would be to invert the logic and to
# define CURL_CREATE_CA_BUNDLE only for packages that need such a bundle
# 
ifdef CURL_SKIP_CA_BUNDLE
PLIST_TRANSFORM = sed -e '/rsc:cert.pem/d'
EXTRA_POST_INSTALL =
else
EXTRA_POST_INSTALL = generate_ca_bundle
endif


include ../../mk/spksrc.cross-cc.mk

.PHONY: curl_post_install
curl_post_install: $(EXTRA_POST_INSTALL)
	sed -i.orig 's#prefix=/#prefix=$(INSTALL_DIR)/#' $(STAGING_INSTALL_PREFIX)/bin/curl-config

.PHONY: generate_ca_bundle
generate_ca_bundle:
	$(WORK_DIR)/$(PKG_DIR)/lib/mk-ca-bundle.pl -u $(STAGING_INSTALL_PREFIX)/cert.pem
