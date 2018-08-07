PKG_NAME = Comskip
PKG_VERS = 0.82.003
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/erikkaashoek/Comskip/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ffmpeg cross/argtable

HOMEPAGE = http://www.kaashoek.com/comskip
COMMENT  = Commercial detector
LICENSE  = GNU/LGPL

PRE_CONFIGURE_TARGET = myPreConfigure
GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ; ./autogen.sh
