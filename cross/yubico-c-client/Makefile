PKG_NAME = yubico-c-client
PKG_SUBNAME = ykclient
PKG_VERS = 2.14
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Yubico/yubico-c-client/archive/ykclient-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_SUBNAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/Yubico/yubico-c-client
COMMENT  = YubiKey C Client Library: libykclient
LICENSE  = BSD

DEPENDS = cross/curl cross/yubico-c-libyubikey

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = myPreConfigure 

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoreconf --install
