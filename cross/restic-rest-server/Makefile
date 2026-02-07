PKG_NAME = restic-rest-server
PKG_REAL_NAME = rest-server
PKG_VERS = 0.12.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/restic/rest-server/releases/download/v$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)

BUILD_DEPENDS = native/go

HOMEPAGE = https://restic.net/
COMMENT  = Rest Server is a high performance HTTP server that implements restic's REST backend API.
LICENSE  = BSD 2-Clause License

GO_SRC_DIR = $(EXTRACT_PATH)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

ENV += CGO_ENABLED=0

GO_BUILD_ARGS = ./cmd/rest-server

include ../../mk/spksrc.cross-go.mk
