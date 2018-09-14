SPK_NAME = zerotier
SPK_VERS = 1.2.12
SPK_REV = 0
SPK_ICON = src/zerotier.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Joseph Henry @ ZeroTier, Inc.
DESCRIPTION = A Simple global P2P encrypted LAN for all of your devices.
CHANGELOG = Various performance upgrades and bugfixes to core service.
HOMEPAGE = https://my.zerotier.com
REPORT_URL = https://github.com/zerotier/ZeroTierNAS/issues
DISPLAY_NAME = ZeroTier

DSM_UI_DIR = ui
RELOAD_UI = yes
OS_MIN_VERS = 6.0-7321
FIRMWARE = 6.0-7321
STARTABLE = yes

LICENSE  = GPLv3
INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

PRE_STRIP_TARGET = zerotier_install

include ../../mk/spksrc.spk.mk

PRODUCT_DIR=$(WORK_DIR)/$(DISPLAY_NAME)One-$(SPK_VERS)
.PHONY: zerotier_install
zerotier_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 -d $(STAGING_DIR)/ui
	install -m 755 $(PRODUCT_DIR)/zerotier-one $(STAGING_DIR)/bin/zerotier-one
	cp -r src/ui/* $(STAGING_DIR)/ui
