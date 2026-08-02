PKG_NAME = libmediainfo
PKG_VERS = 25.04
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MediaArea/MediaInfoLib/archive
PKG_DIST_FILE = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIR = MediaInfoLib-$(PKG_VERS)/Project/GNU/Library

DEPENDS = cross/libzen cross/zlib

# cross/libzen:
MIN_GCC_VERSION = 4.7

HOMEPAGE = https://mediaarea.net/en/MediaInfo
COMMENT  = MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files.
LICENSE  = 2-Clause BSD

PRE_CONFIGURE_TARGET = libmediainfo_pre_configure
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

libmediainfo_pre_configure:
	$(RUN) ; ./autogen.sh
