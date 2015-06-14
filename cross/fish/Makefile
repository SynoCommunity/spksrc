PKG_NAME = fish
PKG_FULL_NAME = fish-shell
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 0ddd0ed
PKG_DIST_SITE = https://github.com/fish-shell/$(PKG_FULL_NAME).git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

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
