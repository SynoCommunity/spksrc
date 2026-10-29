SPK_NAME = synocli-kernel
SPK_VERS = 2.0
SPK_REV = 12
SPK_ICON = src/synocli-kernel.png

DEPENDS = cross/usbutils cross/psmisc

MAINTAINER    = th0ma7
DESCRIPTION   = "SynoCli Kernel Tools provides a set of small command-line utilities: fuser, usb-devices, usbhid-dump. Additionally synocli-kernelmodule loads the kernel modules of synokernel packages, by device profile, and holds the profiles of their devices."
DISPLAY_NAME  = SynoCli Kernel Tools
STARTABLE     = no
CHANGELOG     = "1. Profiles of the USB WiFi adapters of synokernel-wifi"

HOMEPAGE = https://docs.synocommunity.com/packages/synocli-kernel/
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_COMMANDS  = bin/synocli-kernelmodule
SPK_COMMANDS += bin/fuser
SPK_COMMANDS += bin/usb-devices
SPK_COMMANDS += bin/usbhid-dump
SPK_COMMANDS += bin/lsusb.py

POST_STRIP_TARGET = synocli-kernel_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: synocli-kernel_extra_install
synocli-kernel_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/synocli-kernelmodule.sh $(STAGING_DIR)/bin/synocli-kernelmodule
	@# The device profiles, per package of kernel modules, and their udev rules:
	@# a new device only needs this package
	for dir in src/profiles/*/; do \
	  install -m 755 -d $(STAGING_DIR)/etc/profiles/$$(basename $$dir) ; \
	  install -m 644 $$dir*.json $(STAGING_DIR)/etc/profiles/$$(basename $$dir)/ ; \
	done
	install -m 755 -d $(STAGING_DIR)/etc/rules.d
	install -m 644 src/rules.d/*.rules $(STAGING_DIR)/etc/rules.d/
