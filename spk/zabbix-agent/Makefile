SPK_NAME = zabbix-agent
SPK_VERS = 7.4.7
SPK_REV = 1
SPK_ICON = src/zabbix.png

DEPENDS = cross/zabbix-agent

MAINTAINER = SynoCommunity
DESCRIPTION = Monitor anything - networks, cloud, websites, IoT, and more. Zabbix Agent is a Zabbix daemon for monitoring of various server parameters.
DISPLAY_NAME = Zabbix Agent

CHANGELOG = "Initial package release."

HOMEPAGE = https://www.zabbix.com
LICENSE  = AGPLv3

SERVICE_USER = auto
STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
WIZARDS_DIR = src/wizard/

# agent does not have an UI
NO_SERVICE_SHORTCUT = yes
SERVICE_PORT = 10050
SERVICE_PORT_TITLE = Zabbix Agent

POST_STRIP_TARGET = zabbix-agent_extra_install

SPK_COMMANDS = bin/zabbix_get bin/zabbix_sender

include ../../mk/spksrc.spk.mk

.PHONY: zabbix-agent_extra_install
zabbix-agent_extra_install:
	@$(MSG) "Add configuration file"
	@install -d -m 755 $(STAGING_DIR)/var/zabbix_agentd.conf.d
	@install -m 644 src/zabbix_agentd.conf $(STAGING_DIR)/var/zabbix_agentd.conf
