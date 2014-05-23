SPK_NAME = zabbixagent
SPK_VERS = 2.2.2
SPK_REV = 1
SPK_ICON = src/zabbix.png
DSM_UI_DIR = app
BETA = 1
FIRMWARE = 5.0-4418

DEPENDS = cross/busybox cross/$(SPK_NAME)
SPK_CONFLICT = "zabbix"

MAINTAINER = SynoCommunity
DESCRIPTION = The Enterprise-class Monitoring Solution for Everyone. This is the zabbix Agent only.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Zabbix Agent
CHANGELOG = "Initial release"

HOMEPAGE = http://www.zabbix.com/
LICENSE  =
HELPURL    = https://www.zabbix.com/documentation/2.2

WIZARDS_DIR = 

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = zabbix_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"


include ../../mk/spksrc.spk.mk

.PHONY: zabbix_extra_install
zabbix_extra_install:
	install -m 757 -d $(STAGING_DIR)/var
	install -m 757 -d $(STAGING_DIR)/etc/zabbix_agent.conf.d
	install -m 757 -d $(STAGING_DIR)/etc/zabbix_agentd.conf.d
	install -m 755 -d $(STAGING_DIR)/app/gui_images
	install -m 755 -d $(STAGING_DIR)/app/scripts
	install -m 755 -d $(STAGING_DIR)/app/enable

	install -m 644 src/zabbix_agent.conf $(STAGING_DIR)/etc/zabbix_agent.conf
	install -m 644 src/zabbix_agentd.conf $(STAGING_DIR)/etc/zabbix_agentd.conf
	install -m 755 src/z_agent_start_stop.sh $(STAGING_DIR)/sbin/
	
	install -m 644 src/app/config $(STAGING_DIR)/app/
	install -m 644 src/app/*.js $(STAGING_DIR)/app/
	install -m 644 src/app/*.html $(STAGING_DIR)/app/
	install -m 755 src/app/*.cgi $(STAGING_DIR)/app/
	install -m 755 src/app/scripts/*.cgi $(STAGING_DIR)/app/scripts/
	install -m 644 src/app/scripts/*.txt $(STAGING_DIR)/app/scripts/
	install -m 644 src/app/gui_images/* $(STAGING_DIR)/app/gui_images/

	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done