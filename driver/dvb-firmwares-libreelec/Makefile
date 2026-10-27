PKG_NAME = dvb-firmwares-libreelec
PKG_VERS = 2025.06.29
PKG_EXT = tar.gz
PKG_GIT_HASH = 90261ae2934329f6ca84dd6c72d10d0777bf4b0e
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/LibreELEC/dvb-firmware/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = dvb-firmware-$(PKG_GIT_HASH)

HOMEPAGE = https://github.com/LibreELEC/dvb-firmware
COMMENT  = Firmware files of DVB tuners and demodulators, as collected by LibreELEC: si2168, si2157/2158/2141, m88ds3103, mn8847x and others the LinuxTV set lacks.
LICENSE  = Each firmware is licensed under its own terms

# Firmware only: nothing to build against the kernel, installed with each one
CONFIGURE_TARGET = nop
COMPILE_TARGET   = nop
INSTALL_TARGET   = dvb-firmwares-libreelec_install

include ../../mk/spksrc.driver.mk

.PHONY: dvb-firmwares-libreelec_install
dvb-firmwares-libreelec_install:
	cd $(WORK_DIR)/$(PKG_DIR)/firmware && find . -type f -exec install -D -m 644 {} $(STAGING_INSTALL_PREFIX)/lib/firmware/{} \;
