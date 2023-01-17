PKG_NAME = attr
PKG_VERS = 2.4.46
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = http://download.savannah.gnu.org/releases/attr
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://kernel.org/
COMMENT  = Extended attribute package
LICENSE  = GPLv2+

PRE_CONFIGURE_TARGET = myPreConfigure
INSTALL_TARGET = myInstall
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-static=no


include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoconf

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) DIST_ROOT=$(INSTALL_DIR) install-lib install-dev
