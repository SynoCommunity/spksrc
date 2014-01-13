SPK_NAME = zabbixserver
SPK_VERS = 2.2.0
SPK_REV = 1
SPK_ICON = src/zabbix.png
DSM_UI_DIR = app
BETA = 1

DEPENDS = cross/mysql cross/curl cross/libxml2 cross/openipmi cross/iksemel cross/$(SPK_NAME)

MAINTAINER = Zabbix Team, Packaged by SynoCommunity, RustyPixel
DESCRIPTION = The Enterprise-class Monitoring Solution for Everyone.This is the server only with support for zabbix agent, ipmi, vmachine monitoiring and jabber notification.
ADMIN_URL = /zabbix/
RELOAD_UI = yes
DISPLAY_NAME = Zabbix Server
CHANGELOG = "1. Net-snmp support will follow shortly."

HOMEPAGE = http://www.zabbix.com/
LICENSE  =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = zabbix_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: zabbix_extra_install
zabbix_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/frontends/zabbix

	cp -r $(WORK_DIR)/zabbix-$(SPK_VERS)/frontends/php/* $(STAGING_DIR)/frontends/zabbix
	cp -r $(WORK_DIR)/zabbix-$(SPK_VERS)/database/mysql/schema.sql $(STAGING_DIR)/app/schema.sql
	cp -r $(WORK_DIR)/zabbix-$(SPK_VERS)/database/mysql/data.sql $(STAGING_DIR)/app/data.sql
	cp -r $(WORK_DIR)/zabbix-$(SPK_VERS)/database/mysql/images.sql $(STAGING_DIR)/app/images.sql

	install -m 644 src/zabbix.conf.php $(STAGING_DIR)/frontends/zabbix/conf/zabbix.conf.php
	install -m 644 src/.htaccess.txt $(STAGING_DIR)/frontends/zabbix
		
	install -m 644 src/zabbix_server.conf $(STAGING_DIR)/etc/zabbix_server.conf
	
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
