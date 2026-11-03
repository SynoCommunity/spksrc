PKG_NAME = gotify-cli
PKG_VERS = 2.4.0
PKG_COMMIT = 1a3712544653db1ca4d12bb52779be80ea152c79
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/gotify/cli/archive/refs/tags
PKG_DIST_FILE = gotify-cli-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = cli-$(PKG_VERS)

HOMEPAGE = https://gotify.net/
COMMENT  = A command line interface for pushing messages to gotify/server.
LICENSE  = MIT

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/gotify-cli
GO_BUILD_ARGS = -trimpath
BUILD_DATE = $(shell date -u -d @$(or $(SOURCE_DATE_EPOCH),$(shell date +%s)) +%Y-%m-%dT%H:%M:%SZ)
GO_LDFLAGS = -s -w -X main.Version=$(PKG_VERS) -X main.Commit=$(PKG_COMMIT) -X main.BuildDate=$(BUILD_DATE)

include ../../mk/spksrc.cross-go.mk
