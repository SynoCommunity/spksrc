PKG_NAME = libogg
PKG_VERS = 1.3.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.xiph.org/releases/ogg
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.vorbis.com/
COMMENT  = Free, open container format
LICENSE  = BSD


GNU_CONFIGURE = 1
CONFIGURE_ARGS = --libdir=$(INSTALL_PREFIX)/lib

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

