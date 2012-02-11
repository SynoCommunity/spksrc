PKG_NAME = flac
PKG_VERS = 1.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/flac/$(PKG_NAME)-src/$(PKG_NAME)-$(PKG_VERS)-src
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libogg

MAINTAINER=	http://packages.nas-forum.com/
HOMEPAGE=	http://flac.sourceforge.net/
COMMENT=	Free Lossless Audio Codec
LICENSE=	GPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

