PKG_NAME = mono
PKG_VERS = 6.12.0.122
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.mono-project.com/sources/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.mono-project.com
COMMENT  = Cross platform, open source .NET development framework
LICENSE  = https://github.com/mono/mono/blob/master/LICENSE

GNU_CONFIGURE = 1

POST_INSTALL_TARGET = mono_native_post_install

include ../../mk/spksrc.native-cc.mk

.PHONY: mono_native_post_install
mono_native_post_install:
	sed -i -e 's#/usr/local#/var/packages/mono/target#g' $(WORK_DIR)/install/usr/local/bin/*
	sed -i -e 's#/usr/local#/var/packages/mono/target#g' $(WORK_DIR)/install/usr/local/etc/mono/config
