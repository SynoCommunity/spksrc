PKG_NAME = libdnet
PKG_VERS = 1.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(PKG_DIR)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://libdnet.sourceforge.net/
COMMENT  = libdnet provides a simplified, portable interface to several low-level networking routines

GNU_CONFIGURE = 1
POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

myPostInstall:
	ln -fs libdnet.1.0.1 $(STAGING_INSTALL_PREFIX)/lib/libdnet.so.1.0.1
	ln -fs libdnet.so.1.0.1 $(STAGING_INSTALL_PREFIX)/lib/libdnet.so.1
	ln -fs libdnet.so.1.0.1 $(STAGING_INSTALL_PREFIX)/lib/libdnet.so
