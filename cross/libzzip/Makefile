PKG_NAME = zziplib
PKG_VERS_MAIN = 13
PKG_VERS = 0.$(PKG_VERS_MAIN).62
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/$(PKG_NAME)/files/$(PKG_NAME)$(PKG_VERS_MAIN)/$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://zziplib.sourceforge.net/
COMMENT  = Extract data from files archived in a single zip file
LICENSE  = 

CONFIGURE_ARGS  = --disable-static
CONFIGURE_TARGET = myConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:
	$(RUN) ./configure $(TC_CONFIGURE_ARGS) $(CONFIGURE_ARGS)

