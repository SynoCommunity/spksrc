SPK_NAME = icinga2-agent
SPK_VERS = 2.15.2
SPK_REV = 1
SPK_ICON = src/icinga2.png

DEPENDS = cross/icinga2-agent
DEPENDS += cross/monitoring-plugins

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

MAINTAINER = SynoCommunity
DESCRIPTION = Icinga 2 agent connects to an Icinga 2 master server for distributed monitoring.
CHANGELOG = "Initial release of Icinga 2 Agent"

DISPLAY_NAME = Icinga 2 Agent

HOMEPAGE = https://icinga.com/
LICENSE = GPLv2

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
NO_SERVICE_SHORTCUT = yes
WIZARDS_DIR = src/wizard

POST_STRIP_TARGET = icinga2_agent_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: icinga2_agent_extra_install
icinga2_agent_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/templates
	install -m 644 $(CURDIR)/src/templates/*.conf $(STAGING_DIR)/share/templates/
	install -m 755 -d $(STAGING_DIR)/etc/icinga2/features-enabled
	install -m 755 -d $(STAGING_DIR)/etc/icinga2/features-available
