PKG_NAME = fzf
PKG_VERS = 0.74.3
PKG_EXT = tar.gz
PKG_REVISION = $(shell date +%m/%d/%Y)
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/junegunn/fzf/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# Builds with go 1.23, so for kernels older than 3.2 (ARMv5) too
MIN_GO_VERSION = 1.23

HOMEPAGE = https://junegunn.github.io/fzf/
COMMENT  = A command-line fuzzy finder.
LICENSE  = MIT

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

GO_BUILD_ARGS += -ldflags "-s -w -X main.version=$(PKG_VERS) -X main.revision=$(PKG_REVISION)"

include ../../mk/spksrc.cross-go.mk
