PKG_NAME = codec2
PKG_VERS = 1.0.3
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/drowe67/codec2/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/codec2

HOMEPAGE = https://www.rowetel.com/
COMMENT  = Codec 2 is an open source (LGPL 2.1) low bit rate speech codec.
LICENSE  = LGPL 2.1

CMAKE_ARGS  = -DUNITTEST=FALSE
CMAKE_ARGS += -DGENERATE_CODEBOOK=$(WORK_DIR)/../../../native/codec2/work-native/install/usr/local/bin/generate_codebook

include ../../mk/spksrc.cross-cmake.mk
