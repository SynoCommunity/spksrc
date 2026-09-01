PKG_NAME = mediainfo
PKG_VERS = 26.05
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MediaArea/MediaInfo/archive
PKG_DIST_FILE = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIR = MediaInfo-$(PKG_VERS)/Project/GNU/CLI

DEPENDS = cross/libmediainfo-latest

# 26.x requires GCC >= 5 (selected by cross/mediainfo)
MIN_GCC_VERSION = 5

HOMEPAGE = https://mediaarea.net/en/MediaInfo
COMMENT  = MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files.
LICENSE  = 2-Clause BSD

PRE_CONFIGURE_TARGET = mediainfo_pre_configure
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: mediainfo_pre_configure
mediainfo_pre_configure:
	$(RUN) ; ./autogen.sh
