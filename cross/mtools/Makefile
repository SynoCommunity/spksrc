PKG_NAME = mtools
PKG_VERS = 4.0.18
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnu.org/software/mtools/
COMMENT  = Mtools is a collection of utilities to access MS-DOS disks from GNU and Unix without mounting them
LICENSE  = GPLv3

POST_INSTALL_TARGET = myPostInstall

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

myPostInstall:
	mkdir -p $(STAGING_INSTALL_PREFIX)/etc
	sed -e '/^SAMPLE FILE/d' $(WORK_DIR)/$(PKG_DIR)/mtools.conf > $(STAGING_INSTALL_PREFIX)/etc/mtools.conf
