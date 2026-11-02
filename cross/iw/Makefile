PKG_NAME = iw
PKG_VERS = 6.9
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.kernel.org/pub/software/network/iw
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libnl

HOMEPAGE = https://wireless.docs.kernel.org/en/latest/en/users/documentation/iw.html
COMMENT  = iw is the nl80211 based configuration utility for wireless devices.
LICENSE  = ISC

CONFIGURE_TARGET = nop
COMPILE_TARGET   = iw_compile_target
INSTALL_TARGET   = iw_install_target

include ../../mk/spksrc.cross-cc.mk

.PHONY: iw_compile_target
iw_compile_target:
	$(RUN) $(MAKE)

.PHONY: iw_install_target
iw_install_target:
	$(RUN) install -Dm755 iw -t $(STAGING_INSTALL_PREFIX)/sbin
