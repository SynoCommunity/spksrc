PKG_NAME = gickup
PKG_VERS = 0.10.45
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/cooperspencer/gickup/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go

UNSUPPORTED_ARCHS = $(PPC_ARCHS)
# go > 1.23 not supported:
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

HOMEPAGE = https://gickup.dev/
COMMENT = Backup your Git repositories with ease.
LICENSE = Apache 2.0

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

GO_BUILD_ARGS += -ldflags "-s -w -X main.version=$(PKG_VERS)"

include ../../mk/spksrc.cross-go.mk
