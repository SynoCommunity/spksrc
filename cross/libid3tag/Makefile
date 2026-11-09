PKG_NAME = libid3tag
PKG_VERS = 0.16.4
PKG_EXT = tar.gz
PKG_DIST_NAME = id3tag-$(PKG_VERS)-source.tar.gz
PKG_DIST_SITE = https://codeberg.org/tenacityteam/libid3tag/releases/download/$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = id3tag-$(PKG_VERS)-source

DEPENDS = cross/zlib

HOMEPAGE = https://codeberg.org/tenacityteam/libid3tag
COMMENT  = ID3 tag manipulation library, part of MAD: MPEG Audio Decoder.
LICENSE  = GPL

CONFIGURE_ARGS  = -DBUILD_SHARED_LIBS=ON

include ../../mk/spksrc.cross-cmake.mk
