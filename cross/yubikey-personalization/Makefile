PKG_NAME = yubikey-personalization
PKG_VERS = 1.17.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Yubico/yubikey-personalization/archive/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/Yubico/yubikey-personalization
COMMENT  = yubikey-personalization Tools
LICENSE  = BSD

DEPENDS = cross/yubico-c-libyubikey cross/libusb

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = myPreConfigure

HOMEPAGE = https://github.com/Yubico/yubikey-personalization
COMMENT  = yubikey-personalization Tools
LICENSE  = BSD

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) autoreconf --install
