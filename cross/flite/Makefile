
PKG_NAME = flite
PKG_VERS = 1.4
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)-release
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-release.$(PKG_EXT)
PKG_DIST_SITE = http://www.speech.cs.cmu.edu/$(PKG_NAME)/packed/$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/alsa-lib

MAINTAINER=	http://packages.nas-forum.com/
HOMEPAGE=	http://www.speech.cs.cmu.edu/flite/index.html
COMMENT=	Festival-lite is a small, fast run-time synthesis engine
LICENSE=	

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
