PKG_NAME = wireguard
PKG_VERS = 0.0.20190227
PKG_EXT = tar.xz
PKG_DIST_SITE = https://git.zx2c4.com/WireGuard/snapshot
PKG_DIST_NAME = WireGuard-$(PKG_VERS).$(PKG_EXT)
PKG_DIR =  $(PKG_NAME)-$(PKG_VERS)
MOD_DIR = /lib/modules

REQ_KERNEL = 1

HOMEPAGE = https://www.wireguard.com
COMMENT  = WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache.
LICENSE  = GPLv2

DEPENDS = cross/libmnl

CONFIGURE_TARGET = nope

COMPILE_TARGET = wireguard-compile
INSTALL_TARGET = wireguard-install

include ../../mk/spksrc.cross-cc.mk

.PHONY: wireguard-compile wireguard-install
wireguard-compile:
	$(RUN) && cd $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/src && KERNELDIR=$(KERNEL_DIR) $(MAKE)
wireguard-install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/src/tools/wg $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/src/tools/wg-quick/linux.bash $(STAGING_INSTALL_PREFIX)/bin/wg-quick
	install -m 644 $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/src/wireguard.ko $(STAGING_INSTALL_PREFIX)/
