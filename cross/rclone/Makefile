PKG_NAME = rclone
PKG_VERS = 1.71.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rclone/rclone/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)

BUILD_DEPENDS = native/go

UNSUPPORTED_ARCHS = $(PPC_ARCHS)
# rclone 1.70.3 is the last version that builds with go < 1.24
# and go >= 1.24 requires a linux kernel >= 3.2
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

HOMEPAGE = https://rclone.org/
COMMENT  = Rclone is a command-line program to manage files on cloud storage. It is a feature-rich alternative to cloud vendors' web storage interfaces.
LICENSE  = MIT

GO_SRC_DIR = $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

GO_BUILD_ARGS += -ldflags "-s -X github.com/rclone/rclone/fs.Version=v$(PKG_VERS)"

include ../../mk/spksrc.cross-go.mk
