SPK_NAME = synocli-kernel
SPK_VERS = 1.2
SPK_REV = 9
SPK_ICON = src/synocli-kernel.png

DEPENDS = cross/usbutils cross/psmisc

MAINTAINER    = th0ma7
DESCRIPTION   = "SynoCli Kernel Tools provides a set of small command-line utilities: fuser, usb-devices, usbhid-dump"
OPTIONAL_DESC =
DISPLAY_NAME  = SynoCli Kernel Tools
STARTABLE     = no
CHANGELOG     = "1. Add support for r1000 arch"

HOMEPAGE = https://synocommunity.com/
LICENSE  = Each tool is licensed under it\'s respective license.

SPK_LINKS     = /usr/local/bin/synocli-kernelmodule:bin/synocli-kernelmodule.sh
SPK_COMMANDS  = bin/fuser
SPK_COMMANDS += bin/usb-devices
SPK_COMMANDS += bin/usbhid-dump
SPK_COMMANDS += bin/lsusb.py

POST_STRIP_TARGET = synocli-kernel_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: synocli-kernel_extra_install
synocli-kernel_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/synocli-kernelmodule.sh $(STAGING_DIR)/bin/
