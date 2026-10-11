PKG_NAME = qui
PKG_VERS = 1.31.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/autobrr/qui/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go native/nodejs native/pnpm

DEPENDS =

UNSUPPORTED_ARCHS = $(PPC_ARCHS)

HOMEPAGE = https://getqui.com/
COMMENT = A fast, single-binary qBittorrent web UI: manage multiple instances, automate torrent workflows, and cross-seed across trackers.
LICENSE = GPLv2

COMPILE_TARGET = qui_compile

GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)

# avoid version from git tag:
ENV += VERSION=$(PKG_VERS)

include ../../mk/spksrc.cross-go.mk

PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(WORK_DIR)/../../../native/pnpm/work-native/bin:$(PATH)

.PHONY: qui_compile
qui_compile:
	@$(MSG) "- build with make build"
	@$(RUN) $(MAKE) build
