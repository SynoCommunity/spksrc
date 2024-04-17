PKG_NAME = adguardhome
PKG_VERS = 0.107.48
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/AdguardTeam/$(PKG_NAME)/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://github.com/AdguardTeam/$(PKG_NAME)
COMMENT  = Network-wide ads & trackers blocking DNS server
LICENSE  = GPL-3.0 license

GO_SRC_DIR = $(WORK_DIR)/AdGuardHome-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

include ../../mk/spksrc.cross-go.mk