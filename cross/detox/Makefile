PKG_NAME = detox
PKG_VERS = 1.2.0
PKG_VERS_CUT = -1.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.heanet.ie/mirrors/download.sourceforge.net/pub/sourceforge/d/de/detox/detox/1.2.0
PKG_DIR = $(PKG_NAME)$(PKG_VERS_CUT)

#DEPENDS = cross/ncurses

HOMEPAGE = http://detox.sourceforge.net/
COMMENT  = Detox is a utility designed to clean up filenames. It replaces difficult to work with characters, such as spaces, with standard equivalents. 
LICENSE  = GPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = 

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
	install -m 644 src/detox $(STAGING_INSTALL_PREFIX)/share/detox/detox
