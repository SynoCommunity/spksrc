PKG_NAME = wireguard
PKG_VERS = 1.0.20210124
PKG_EXT = tar.xz
PKG_DIST_SITE = https://git.zx2c4.com/wireguard-linux-compat/snapshot
PKG_DIST_NAME = wireguard-linux-compat-$(PKG_VERS).$(PKG_EXT)
PKG_DIR =  wireguard-linux-compat-$(PKG_VERS)

DEPENDS = cross/libmnl

REQUIRE_KERNEL = 1

HOMEPAGE = https://www.wireguard.com
COMMENT  = WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache.
LICENSE  = GPLv2

ENV += KERNELDIR=$(WORK_DIR)/linux

CONFIGURE_TARGET = noop
COMPILE_TARGET = wireguard-compile
INSTALL_TARGET = wireguard-install

include ../../mk/spksrc.cross-cc.mk

.PHONY: wireguard-compile wireguard-install
wireguard-compile:
	$(RUN) DESTDIR=$(STAGING_INSTALL_PREFIX) $(MAKE) -C src/ module
wireguard-install:
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/src/wireguard.ko $(STAGING_INSTALL_PREFIX)/
