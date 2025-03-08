PKG_NAME = git-lfs
PKG_VERS = 3.6.1
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

# The only documentation found on how to build git-lfs with working --help parameter 
# to avoid: Sorry, no usage text found for "git-lfs"
# https://github.com/git-lfs/git-lfs/issues/672#issuecomment-141392648
# but instead of calling "go generate ./commands" let's use the Makefile target "mangen"
CONFIGURE_TARGET = git-lfs_configure

ENV += GO111MODULE=on

# If Git LFS is being built for a published release, VERSION and GIT_LFS_SHA
# should be identical.
export VERSION=$(PKG_VERS)
export GIT_LFS_SHA=$(PKG_VERS)

include ../../mk/spksrc.cross-go.mk

.PHONY: git-lfs_configure
# build mangen tool for the host arch
# and update commands/mancontent_gen.go to have command usage available.
git-lfs_configure:
	@$(MSG) Prepare to include commands usage
	@$(RUN) $(MAKE) mangen
