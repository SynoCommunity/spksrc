PKG_NAME = yubico-c-libyubikey
PKG_VERS = 1.13
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Yubico/yubico-c/archive/libyubikey-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/Yubico/yubico-c
COMMENT  = libyubikey (Yubico-c Lib)
LICENSE  = BSD

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoreconf --install
