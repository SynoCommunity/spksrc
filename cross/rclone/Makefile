PKG_NAME = rclone
PKG_VERS = 1.75.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rclone/rclone/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

MIN_GO_VERSION = 1.26.0
# A client: copy, sync and check never call accept4, which go 1.24 and later need from Linux 3.2,
# so they run on the ARMv5 2.6.32 kernel (tested on a DS212j); rclone serve and rcd cannot there.
MIN_KERNEL_VERSION =

HOMEPAGE = https://rclone.org/
COMMENT  = Rclone is a command-line program to manage files on cloud storage. It is a feature-rich alternative to cloud vendors' web storage interfaces.
LICENSE  = MIT

GO_SRC_DIR = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

GO_BUILD_ARGS += -trimpath -ldflags "-s -X github.com/rclone/rclone/fs.Version=v$(PKG_VERS)"

include ../../mk/spksrc.cross-go.mk
