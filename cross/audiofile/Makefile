PKG_NAME = audiofile
PKG_VERS = 0.3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://audiofile.68k.org
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/alsa-lib

MAINTAINER=	http://packages.nas-forum.com/
HOMEPAGE=	http://www.68k.org/~michael/audiofile/
COMMENT=	Handle reading and writing audio files in many common formats
LICENSE=	LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

