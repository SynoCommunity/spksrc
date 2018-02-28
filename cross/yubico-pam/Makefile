PKG_NAME = yubico-pam
PKG_VERS = 2.19
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Yubico/yubico-pam/archive/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/linux-pam cross/yubico-c-client cross/yubikey-personalization

HOMEPAGE = https://github.com/Yubico/yubico-pam
COMMENT  = The Yubico PAM module provides an easy way to integrate the Yubikey into your existing user authentication infrastructure
LICENSE  = BSD

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	ln -s $(INSTALL_DIR)/$(INSTALL_PREFIX)/include $(INSTALL_DIR)/$(INSTALL_PREFIX)/include/security
	$(RUN) autoreconf --install
