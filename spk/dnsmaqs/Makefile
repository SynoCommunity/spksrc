SPK_NAME = dnsmasq
SPK_VERS = 2.63
SPK_REV = 1
SPK_ICON = src/dnsmasq.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Dominique Gallot
DESCRIPTION = Dnsmasq is a lightweight, easy to configure DNS forwarder and DHCP server.
ADMIN_URL = 
RELOAD_UI = yes
DISPLAY_NAME = dnsmasq
CHANGELOG = "1. Initial release"

HOMEPAGE = http://www.thekelleys.org.uk
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = dnsmasq_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: dnsmasq_extra_install
dnsmasq_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/lease
	install -m 755 -d $(STAGING_DIR)/log
	install -m 755 -d $(STAGING_DIR)/app/log
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/index.php $(STAGING_DIR)/app/index.php
	install -m 644 src/etc/dnsmasq.conf $(STAGING_DIR)/etc/dnsmasq.conf
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)_$${size}.png ; \
	done

