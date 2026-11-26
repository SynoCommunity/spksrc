PKG_NAME = usbsync
PKG_VERS = 1.9.7
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/alirz1/usbsync/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
EXTRACT_PATH = $(WORK_DIR)/src/github.com/

HOMEPAGE = https://github.com/alirz1/usbsync
COMMENT  = Sync NAS shared folders to and from USB/eSATA drives with rsync.
LICENSE  = BSD-3-Clause

# The Go module lives in src/ inside the release archive
GO_SRC_DIR = $(EXTRACT_PATH)/$(PKG_NAME)-$(PKG_VERS)/src
GO_BIN_DIR = $(GO_SRC_DIR)/usbsync

GO_BUILD_ARGS = -trimpath -ldflags "-s -w -X main.version=$(PKG_VERS)"

include ../../mk/spksrc.cross-go.mk
