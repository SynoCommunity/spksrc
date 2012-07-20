SPK_NAME = asterisk
SPK_VERS = 1.8.14.1
SPK_REV = 1
SPK_ICON = src/asterisk.png
DSM_UI_DIR = app
BETA = 1

DEPENDS = cross/busybox cross/$(SPK_NAME) cross/asterisk-gui

MAINTAINER = SynoCommunity
DESCRIPTION = Asterisk is an open source framework for building communications applications. Asterisk turns an ordinary computer into a communications server. Asterisk powers IP PBX systems, VoIP gateways, conference servers and more. It is used by small businesses, large businesses, call centers, carriers and governments worldwide. Asterisk is free and open source. Asterisk is sponsored by Digium
ADMIN_PORT = 8088
RELOAD_UI = yes
DISPLAY_NAME = Asterisk

HOMEPAGE = http://www.asterisk.org/
LICENSE  =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = asterisk_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: asterisk_extra_install
asterisk_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/run
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 755 -d $(STAGING_DIR)/var/spool
	install -m 755 -d $(STAGING_DIR)/var/etc
	install -m 644 src/etc/* $(STAGING_DIR)/var/etc/
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/asterisk.cgi.pl $(STAGING_DIR)/app/asterisk.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

