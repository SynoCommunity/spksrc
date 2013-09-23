PKG_NAME = binutils
PKG_VERS = 2.23.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnu.org/gnu/binutils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.gnu.org/software/binutils/
COMMENT  = A collection of binary tools
LICENSE  = GPLv3, LGPLv3


POST_INSTALL_TARGET = myPostInstall


GNU_CONFIGURE = 1


include ../../mk/spksrc.cross-cc.mk


.PHONY: myPostInstall
myPostInstall:
	$(RUN) cp -f $(WORK_DIR)/../../../cross/$(PKG_NAME)/PLIST.$(ARCH) $(WORK_DIR)/PLIST
