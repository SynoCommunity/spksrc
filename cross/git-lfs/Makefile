PKG_NAME = git-lfs
PKG_VERS = 3.3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/git-lfs/git-lfs/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

BUILD_DEPENDS = native/go

HOMEPAGE = https://git-lfs.com/
COMMENT  = Git extension for versioning large files.
LICENSE  = MIT

GO_SRC_DIR = $(WORK_DIR)/$(PKG_DIR)
GO_BIN_DIR = $(GO_SRC_DIR)/$(PKG_NAME)

ENV += GO111MODULE=on

# If Git LFS is being built for a published release, VERSION and GIT_LFS_SHA
# should be identical.
export VERSION=$(PKG_VERS)
export GIT_LFS_SHA=$(PKG_VERS)

include ../../mk/spksrc.cross-go.mk
