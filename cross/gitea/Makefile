PKG_NAME = gitea
PKG_VERS = 1.15.8
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/go-gitea/gitea/archive/refs/tags
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/nodejs native/go

HOMEPAGE = https://gitea.io/
COMMENT  = Gitea is a community managed lightweight code hosting solution written in Go.
LICENSE  = MIT

ENV += NPM_CONFIG_USER=root
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

CGO_ENABLED=1
COMPILE_TARGET = gitea_compile_target
GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)
include ../../mk/spksrc.cross-go.mk

TAGS = "bindata sqlite sqlite_unlock_notify"
ENV += TAGS=$(TAGS)
ENV += LDFLAGS=""

gitea_compile_target:
	cd $(GO_SRC_DIR) && env $(ENV) $(MAKE) build
