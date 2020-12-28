PKG_NAME = mxml
PKG_VERS = 3.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/michaelrsweet/mxml/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.msweet.org/mxml
COMMENT  = Tiny XML library.
LICENSE  = Apache 2.0

GNU_CONFIGURE = 1
INSTALL_TARGET = mxml_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: mxml_install
mxml_install:
	@$(RUN) $(MAKE) DSTROOT=$(INSTALL_DIR) install
