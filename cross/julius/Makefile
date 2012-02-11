
PKG_NAME = julius
PKG_VERS = 4.2
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://osdn.dl.sourceforge.jp/julius/51820

DEPENDS = cross/zlib cross/libsndfile

MAINTAINER=	http://packages.nas-forum.com/
HOMEPAGE=	http://julius.sourceforge.jp/en/
COMMENT=	Open-Source Large Vocabulary CSR Engine
LICENSE=	http://julius.sourceforge.jp/LICENSE.txt

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
