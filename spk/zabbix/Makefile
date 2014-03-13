SPK_NAME = zabbix
SPK_VERS = 2.2.2
SPK_REV = 1
SPK_ICON = src/zabbix.png
DSM_UI_DIR = app
BETA = 1

DEPENDS = cross/busybox cross/$(SPK_NAME)
SPK_DEPENDS = "Perl"

MAINTAINER = SynoCommunity
DESCRIPTION = The enterprise-class monitoring solution for everyone. This is the complete suite with Server, Proxy and Agent. Support for zabbix agents, ipmi, vmachine monitoring and jabber notifications.
ADMIN_URL = 
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Zabbix
CHANGELOG = "Initial release"

HOMEPAGE = http://www.zabbix.com/
LICENSE  =
HELPURL    = https://www.zabbix.com/documentation/2.2

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql
INSTUNINST_RESTART_SERVICES = apache-web


INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = zabbix_extra_install

# Limit to supported archs
ifneq ($(findstring $(ARCH),bromolow cedarview x86 qoriq),$(ARCH))
$(error Sorry, $(ARCH) is not supported)
endif

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"


include ../../mk/spksrc.spk.mk

.PHONY: zabbix_extra_install
zabbix_extra_install:
	install -m 757 -d $(STAGING_DIR)/var
	install -m 757 -d $(STAGING_DIR)/etc/zabbix_agent.conf.d
	install -m 757 -d $(STAGING_DIR)/etc/zabbix_agentd.conf.d
	install -m 757 -d $(STAGING_DIR)/etc/zabbix_proxy.conf.d
	install -m 755 -d $(STAGING_DIR)/etc/zabbix_server.conf.d
	install -m 755 -d $(STAGING_DIR)/app/gui_images
	install -m 755 -d $(STAGING_DIR)/app/scripts
       
	install -m 644 src/zabbix.conf.php $(STAGING_DIR)/share/zabbix/conf/zabbix.conf.php
	install -m 644 src/zabbix_server.conf $(STAGING_DIR)/etc/zabbix_server.conf
	install -m 644 src/zabbix_proxy.conf $(STAGING_DIR)/etc/zabbix_proxy.conf
	install -m 644 src/zabbix_agent.conf $(STAGING_DIR)/etc/zabbix_agent.conf
	install -m 644 src/zabbix_agentd.conf $(STAGING_DIR)/etc/zabbix_agentd.conf
	install -m 644 src/odbcinst.ini $(STAGING_DIR)/etc/odbcinst.ini
	install -m 644 src/odbc.ini $(STAGING_DIR)/etc/odbc.ini
	install -m 755 src/z_server_start_stop.sh $(STAGING_DIR)/sbin/
	install -m 755 src/z_proxy_start_stop.sh $(STAGING_DIR)/sbin/
	install -m 755 src/z_agent_start_stop.sh $(STAGING_DIR)/sbin/
	
	install -m 644 src/app/config $(STAGING_DIR)/app/
	install -m 755 src/app/*.cgi $(STAGING_DIR)/app/
	install -m 644 src/app/*.pl $(STAGING_DIR)/app/
	install -m 755 src/app/scripts/*.cgi $(STAGING_DIR)/app/scripts/
	install -m 644 src/app/*.css $(STAGING_DIR)/app/
	install -m 644 src/app/gui_images/* $(STAGING_DIR)/app/gui_images/

	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done