PKG_NAME = s3backer
PKG_VERS = 2.1.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/archiecobbs/s3backer/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse cross/libexpat cross/zstd cross/curl

HOMEPAGE = https://github.com/archiecobbs/s3backer/wiki/ManPage
COMMENT  = FUSE-based single file backing store via Amazon S3.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = s3backer_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: s3backer_pre_configure
s3backer_pre_configure:
	@$(RUN) autoreconf -iv
