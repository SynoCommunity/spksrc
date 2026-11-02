PKG_NAME = wpa_supplicant
PKG_VERS = 2.11
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://w1.fi/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/libnl
DEPENDS += cross/openssl3

HOMEPAGE = https://w1.fi/wpa_supplicant/
COMMENT  = WPA supplicant: WPA2 and WPA3 authentication of WiFi stations, with wpa_cli.
LICENSE  = BSD

CONFIGURE_TARGET = wpa_supplicant_configure
COMPILE_TARGET   = wpa_supplicant_compile
INSTALL_TARGET   = wpa_supplicant_install

include ../../mk/spksrc.cross-cc.mk

# The defconfig, with WPA3 (SAE, OWE): no wireless extensions, which the kernels
# of synokernel-wifi lack, nor D-Bus and MACsec, which need what DSM does not ship
.PHONY: wpa_supplicant_configure
wpa_supplicant_configure:
	sed -e 's/^CONFIG_DRIVER_WEXT=y/#CONFIG_DRIVER_WEXT=y/' \
	    -e 's/^CONFIG_DRIVER_MACSEC_LINUX=y/#CONFIG_DRIVER_MACSEC_LINUX=y/' \
	    -e 's/^CONFIG_MACSEC=y/#CONFIG_MACSEC=y/' \
	    -e 's/^CONFIG_CTRL_IFACE_DBUS_NEW=y/#CONFIG_CTRL_IFACE_DBUS_NEW=y/' \
	    -e 's/^CONFIG_CTRL_IFACE_DBUS_INTRO=y/#CONFIG_CTRL_IFACE_DBUS_INTRO=y/' \
	    -e 's/^#CONFIG_OWE=y/CONFIG_OWE=y/' \
	    $(WORK_DIR)/$(PKG_DIR)/wpa_supplicant/defconfig > $(WORK_DIR)/$(PKG_DIR)/wpa_supplicant/.config

.PHONY: wpa_supplicant_compile
wpa_supplicant_compile:
	$(RUN) $(MAKE) -C wpa_supplicant

.PHONY: wpa_supplicant_install
wpa_supplicant_install:
	install -d -m 755 $(STAGING_INSTALL_PREFIX)/sbin
	cd $(WORK_DIR)/$(PKG_DIR)/wpa_supplicant && install -m 755 wpa_supplicant wpa_cli wpa_passphrase $(STAGING_INSTALL_PREFIX)/sbin/
