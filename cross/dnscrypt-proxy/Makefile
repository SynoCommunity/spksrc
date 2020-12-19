PKG_NAME = dnscrypt-proxy
PKG_VERS = 2.0.44
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jedisct1/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/$(PKG_NAME)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/go

HOMEPAGE = https://github.com/jedisct1/dnscrypt-proxy
COMMENT  = A flexible DNS proxy, with support for modern encrypted DNS protocols such as DNSCrypt v2 and DNS-over-HTTP/2.
LICENSE  = ISC

POST_INSTALL_TARGET = dnscrypt_post_install

GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)-$(PKG_VERS)/$(PKG_NAME)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)
GO_LDFLAGS = -s -w

include ../../mk/spksrc.cross-go.mk

dnscrypt_post_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/blocklist
	install -m 644 $(GO_SRC_DIR)/example-* $(STAGING_INSTALL_PREFIX)
	install -m 644 $(GO_SRC_DIR)/../utils/generate-domains-blacklists/* $(STAGING_INSTALL_PREFIX)/blocklist
