PKG_NAME = gotify-cli
PKG_VERS = 2.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gotify/cli/archive
PKG_DIST_FILE = ${PKG_NAME}-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = cli-$(PKG_VERS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://gotify.net/
COMMENT  = A command line interface for pushing messages to gotify/server.
LICENSE  = MIT

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

CGO_ENABLED = 1
GO_BUILD_ARGS += -ldflags "-w -s -X main.Version=$(PKG_VERS) -X main.BuildDate=$(shell date "+%F-%T") -X main.Commit=$(PKG_VERS) -X main.Mode=prod"

include ../../mk/spksrc.cross-go.mk
