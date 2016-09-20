PKG_NAME = openjpeg
PKG_VERS = 2.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/openjpeg.mirror/files/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng cross/libtiff

HOMEPAGE = http://www.openjpeg.org/
COMMENT  = The OpenJPEG library is an open-source JPEG 2000 codec written in C language.
LICENSE  = BSD

CONFIGURE_TARGET = myConfigure

include ../../mk/spksrc.cross-cc.mk

myConfigure:
	$(RUN) cmake -DCMAKE_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)

