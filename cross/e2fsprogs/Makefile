PKG_NAME = e2fsprogs
PKG_VERS = 1.42.6
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/v$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)

DEPENDS =

HOMEPAGE = http://e2fsprogs.sourceforge.net/
COMMENT  = Ext2/3/4 filesystem userspace utilities
LICENSE  = GPL

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-defrag
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install-libs install prefix=$(STAGING_INSTALL_PREFIX)
