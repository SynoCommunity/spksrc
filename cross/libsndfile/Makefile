
PKG_NAME = libsndfile
PKG_VERS = 1.0.25
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://www.mega-nerd.com/libsndfile/files

DEPENDS =

MAINTAINER=	http://packages.nas-forum.com/
HOMEPAGE=	http://www.mega-nerd.com/libsndfile/
COMMENT=	C library for reading and writing files containing sampled sound
LICENSE=	LGPL

GNU_CONFIGURE = 1
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

