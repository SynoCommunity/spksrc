PKG_NAME = dvb-firmwares
PKG_VERS = 2018.05.21
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
# linuxtv.org answers downloads with a bot check page: the archive of
# linuxtv.org/downloads/firmware, kept with the media_build trees
PKG_DIST_SITE = https://github.com/SynoCommunity/spksrc/releases/download/linuxtv%2Fmedia_build
PKG_DIR = firmware

HOMEPAGE = https://linuxtv.org/
COMMENT  = Firmware files of DVB tuners and demodulators, as distributed by LinuxTV.
LICENSE  = Each firmware is licensed under its own terms

# Firmware only: nothing to build against the kernel, installed with each one
CONFIGURE_TARGET = nop
COMPILE_TARGET   = nop
INSTALL_TARGET   = dvb-firmwares_install

include ../../mk/spksrc.driver.mk

.PHONY: dvb-firmwares_install
dvb-firmwares_install:
	install -d -m 755 $(STAGING_INSTALL_PREFIX)/lib/firmware
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/* $(STAGING_INSTALL_PREFIX)/lib/firmware/
