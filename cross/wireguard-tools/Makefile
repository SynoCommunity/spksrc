PKG_NAME = wireguard-tools
PKG_VERS = 1.0.20210315
PKG_EXT = tar.xz
PKG_DIST_SITE = https://git.zx2c4.com/$(PKG_NAME)/snapshot
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)/src

HOMEPAGE = https://www.wireguard.com
COMMENT  = WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache.
LICENSE  = GPLv2

ENV += WITH_WGQUICK=yes
ENV += WITH_BASHCOMPLETION=no
ENV += WITH_SYSTEMDUNITS=no
ENV += PREFIX=$(STAGING_INSTALL_PREFIX)

CONFIGURE_TARGET = nop
INSTALL_TARGET = wireguard-install

include ../../mk/spksrc.cross-cc.mk

.PHONY: wireguard-install
wireguard-install:
	$(RUN) $(MAKE) install
