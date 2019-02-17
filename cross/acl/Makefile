PKG_NAME = acl
PKG_VERS = 2.2.52
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = http://download.savannah.gnu.org/releases/acl
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/attr

HOMEPAGE = http://kernel.org/
COMMENT  = 
LICENSE  = 

GNU_CONFIGURE = 1
INSTALL_TARGET = myInstall
CONFIGURE_ARGS = --enable-static=no

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) DIST_ROOT=$(INSTALL_DIR) install install-lib install-dev
