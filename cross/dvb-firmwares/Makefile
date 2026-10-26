PKG_NAME = dvb-firmwares
PKG_VERS = 2018.05.21
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME).$(PKG_EXT)
PKG_DIST_SITE = https://www.linuxtv.org/downloads/firmware
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = firmware

DEPENDS =

HOMEPAGE = https://linuxtv.org/
COMMENT  = Firmware files of DVB tuners and demodulators, as distributed by LinuxTV.
LICENSE  = Each firmware is licensed under its own terms

INSTALL_TARGET = dvb-firmwares_install

include ../../mk/spksrc.cross-install.mk

.PHONY: dvb-firmwares_install
dvb-firmwares_install:
	install -d -m 755 $(STAGING_INSTALL_PREFIX)/lib/firmware
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/* $(STAGING_INSTALL_PREFIX)/lib/firmware/
