PKG_NAME = libmediainfo
PKG_VERS = 0.7.83
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)_$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://mediaarea.net/download/source/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = MediaInfoLib/Project/GNU/Library

DEPENDS = cross/libzen cross/zlib

HOMEPAGE = http://sourceforge.net/projects/mediainfo/
COMMENT  = MediaInfo is a convenient unified display of the most relevant technical and tag data for video and audio files.
LICENSE  = 

PRE_CONFIGURE_TARGET = myPreConfigure
GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-shared

include ../../mk/spksrc.cross-cc.mk

myPreConfigure:
	$(RUN) ; ./autogen.sh