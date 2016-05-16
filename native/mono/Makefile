PKG_NAME = mono
PKG_VERS_MAJOR = 4.2.2
PKG_VERS_MINOR = 30
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS_MAJOR).$(PKG_VERS_MINOR).$(PKG_EXT)
PKG_DIST_SITE = http://download.mono-project.com/sources/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS_MAJOR)

DEPENDS =

HOMEPAGE   = http://www.mono-project.com
COMMENT    = Cross platform, open source .NET development framework
LICENSE    = https://github.com/mono/mono/blob/master/LICENSE

GNU_CONFIGURE = 1

POST_INSTALL_TARGET = myPostInstall

include ../../mk/spksrc.native-cc.mk

.PHONY: myPostInstall
myPostInstall:
	sed -i -e 's#/usr/local#/usr/local/mono#g' $(WORK_DIR)/install/usr/local/bin/*
	sed -i -e 's#/usr/local#/usr/local/mono#g' $(WORK_DIR)/install/usr/local/etc/mono/config
