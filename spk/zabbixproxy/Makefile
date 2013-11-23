SPK_NAME = zabbixproxy
SPK_VERS = 2.2.0
SPK_REV = 1
SPK_ICON = src/zabbix.png
DSM_UI_DIR = app
BETA = 1

DEPENDS = cross/sqlite cross/openipmi cross/libssh2 cross/curl cross/$(SPK_NAME)

MAINTAINER = Zabbix Team, Packaged by SynoCommunity, RustyPixel
DESCRIPTION = The Enterprise-class Monitoring Solution for Everyone.
ADMIN_PORT = 
RELOAD_UI = no
DISPLAY_NAME = Zabbix Proxy
CHANGELOG = ""

HOMEPAGE = http://www.zabbix.com/
LICENSE  =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = zabbix_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: zabbix_extra_install
zabbix_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app

	install -m 644 src/zabbix_proxy.conf $(STAGING_DIR)/etc/zabbix_proxy.conf

	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
