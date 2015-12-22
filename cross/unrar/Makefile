PKG_NAME = unrar
PKG_VERS = 5.3.8
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.rarlab.com/rar
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = http://rarlab.com
COMMENT  = Extract files from rar archives
LICENSE  = freeware

CONFIGURE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(STAGING_INSTALL_PREFIX)

