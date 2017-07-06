PKG_NAME = libxml2
PKG_VERS = 2.9.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://xmlsoft.org/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://xmlsoft.org
COMMENT  = Libxml2 is the XML C parser and toolkit developed for the Gnome project (but usable outside of the Gnome platform)
LICENSE  = MIT

CONFIGURE_ARGS = --without-python --with-zlib=$(STAGING_INSTALL_PREFIX)
GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -O3
ifeq ($(findstring $(ARCH),88f5281),$(ARCH))
ADDITIONAL_CFLAGS = -O2
endif

POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPostInstall
myPostInstall:
	sed -i -e 's|^prefix=$(INSTALL_PREFIX)$$|prefix=$(STAGING_INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/xml2-config
