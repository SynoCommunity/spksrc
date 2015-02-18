PKG_NAME = sudo
PKG_VERS = 1.8.12
PKG_VERS_CUT = $(PKG_VERS)
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.sudo.ws/sudo/dist
PKG_DIR = $(PKG_NAME)-$(PKG_VERS_CUT)

DEPENDS = 

HOMEPAGE = http://www.vim.org/
COMMENT  = Vim is an advanced text editor that seeks to provide the power of the de-facto Unix editor Vi, with a more complete feature set.
LICENSE  = Charityware

GNU_CONFIGURE = 1
CONFIGURE_ARGS = ""
CONFIGURE_ARGS += ""

INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR)
