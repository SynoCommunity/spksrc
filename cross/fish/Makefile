PKG_NAME = fish
PKG_VERS = 2.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://fishshell.com/files/$(PKG_VERSION)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/ncurses

HOMEPAGE = http://fishshell.com
COMMENT  = fish is a smart and user-friendly command line shell for OS X, Linux, and the rest of the family.
LICENSE  = GPLv2

PRE_CONFIGURE_TARGET = myPreConfigure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix=$(INSTALL_DIR)$(INSTALL_PREFIX)

ENV += CXXFLAGS="-I$(INSTALL_DIR)$(INSTALL_PREFIX)/include" LDFLAGS="-L$(INSTALL_DIR)$(INSTALL_PREFIX)/lib"

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoconf
