PKG_NAME = mediainfo
PKG_VERS = 19.04
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MediaArea/MediaInfo/archive/v$(PKG_VERS)
PKG_DIR = MediaInfo-$(PKG_VERS)/Project/GNU/CLI

DEPENDS = cross/libmediainfo

HOMEPAGE = https://mediaarea.net/en/MediaInfo
COMMENT  = MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files.
LICENSE  = BSD

PRE_CONFIGURE_TARGET = mediainfo_pre_configure
GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-shared

include ../../mk/spksrc.cross-cc.mk

mediainfo_pre_configure:
	$(RUN) ; ./autogen.sh
