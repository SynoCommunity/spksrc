PKG_NAME = s3backer
PKG_VERS = 2.1.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/archiecobbs/s3backer/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fuse3 cross/libexpat cross/zstd cross/curl

# fuse3
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/archiecobbs/s3backer/wiki/ManPage
COMMENT  = FUSE-based single file backing store via Amazon S3.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = s3backer_pre_configure

CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
ADDITIONAL_CFLAGS = -D_FILE_OFFSET_BITS=64
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: s3backer_pre_configure
s3backer_pre_configure:
	@$(RUN) autoreconf -iv
