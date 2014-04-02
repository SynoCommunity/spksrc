SPK_NAME = cpuminer
SPK_VERS = 2.3.3
SPK_REV = 1
SPK_ICON = src/cpuminer.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = eptmp3
DESCRIPTION = "Multi-threaded CPU miner for Litecoin and Bitcoin, fork of Jeff Garzik's reference cpuminer."
ADMIN_PORT = 9091
RELOAD_UI = yes
DISPLAY_NAME = CPUMiner
CHANGELOG = "1. First release"

HOMEPAGE = https://github.com/pooler/cpuminer
LICENSE  = GPLv2

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

POST_STRIP_TARGET = cpuminer_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: cpuminer_extra_install
cpuminer_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/settings.json $(STAGING_DIR)/var/settings.json
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
