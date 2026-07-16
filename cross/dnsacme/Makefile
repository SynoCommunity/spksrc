PKG_NAME = dnsacme
PKG_VERS = 1.0.4
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/mritd/dnsacme/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

UNSUPPORTED_ARCHS = $(32bit_ARCHS)

HOMEPAGE = https://github.com/mritd/dnsacme
COMMENT  = DNS-01 ACME certificate manager with Synology DSM certificate deployment.
LICENSE  = Apache-2.0

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

GO_BUILD_ARGS += -trimpath -tags synology
GO_LDFLAGS  = -s -w
GO_LDFLAGS += -X main.commit=v$(PKG_VERS)

INSTALL_TARGET = dnsacme_install

include ../../mk/spksrc.cross-go.mk

.PHONY: dnsacme_install
dnsacme_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	@install -m 755 $(GO_BIN_DIR) $(STAGING_INSTALL_PREFIX)/bin/
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/ui/images
	@install -m 644 $(GO_SRC_DIR)/synology/spk/ui/DNSACME.js $(STAGING_INSTALL_PREFIX)/ui/
	@install -m 755 $(GO_SRC_DIR)/synology/spk/ui/api.cgi $(STAGING_INSTALL_PREFIX)/ui/
	@install -m 644 $(GO_SRC_DIR)/synology/spk/ui/config $(STAGING_INSTALL_PREFIX)/ui/
	@install -m 644 $(GO_SRC_DIR)/synology/spk/ui/images/*.png $(STAGING_INSTALL_PREFIX)/ui/images/
