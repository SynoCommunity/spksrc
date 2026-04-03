PKG_NAME = adguardhome
PKG_VERS = 0.107.71
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/AdguardTeam/$(PKG_NAME)/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = AdGuardHome-$(PKG_VERS)

BUILD_DEPENDS = native/go native/nodejs
HOMEPAGE = https://github.com/AdguardTeam/$(PKG_NAME)
COMMENT  = Network-wide ads & trackers blocking DNS server
LICENSE  = GPL-3.0

PATCHES_LEVEL = 1
GO_SRC_DIR = $(WORK_DIR)/AdGuardHome-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)
GO_BUILD_ARGS += -ldflags "-X 'github.com/AdguardTeam/AdGuardHome/internal/version.version=v$(PKG_VERS)' -X 'github.com/AdguardTeam/AdGuardHome/internal/version.channel=release'"
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)
PRE_COMPILE_TARGET = adguardhome_pre_compile
# avoid webpack error ERR_OSSL_EVP_UNSUPPORTED with nodejs 18
ENV += NODE_OPTIONS=--openssl-legacy-provider

include ../../mk/spksrc.cross-go.mk

.PHONY: adguardhome_pre_compile
adguardhome_pre_compile:
	@$(RUN) $(MAKE) js-deps
	@$(RUN) $(MAKE) js-build
