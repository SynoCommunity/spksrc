PKG_NAME = mono
PKG_VERS = 3.10.0
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.mono-project.com/sources/mono
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE   = http://www.mono-project.com/
COMMENT    = .NET for linux... dude
LICENSE    =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --host=i386-linux-gnu

POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.native-cc.mk

.PHONY: myPostInstall
myPostInstall:
	sed -i -e 's#/usr/local#/usr/local/mono#g' $(WORK_DIR)/install/usr/local/bin/*
	sed -i -e 's#/usr/local#/usr/local/mono#g' $(WORK_DIR)/install/usr/local/etc/mono/config
