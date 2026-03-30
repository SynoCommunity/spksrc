SPK_NAME = icinga2
SPK_VERS = 2.15.2
SPK_REV = 1
SPK_ICON = src/icinga2.png

DEPENDS = cross/icinga2
DEPENDS += cross/monitoring-plugins
SPK_DEPENDS = MariaDB10

REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

MAINTAINER = SynoCommunity
DESCRIPTION = Icinga 2 is an open source monitoring system which checks the availability of your network resources, notifies users of outages, and generates performance data for reporting.
CHANGELOG = "Initial release of Icinga 2 v2.15.2"

DISPLAY_NAME = Icinga 2

HOMEPAGE = https://icinga.com/
LICENSE = GPLv2

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
NO_SERVICE_SHORTCUT = yes
WIZARDS_DIR = src/wizard

FWPORTS = src/icinga2.sc

POST_STRIP_TARGET = icinga2_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: icinga2_extra_install
icinga2_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/templates
	install -m 644 $(CURDIR)/src/templates/*.conf $(STAGING_DIR)/share/templates/
	install -m 644 $(CURDIR)/src/templates/*.txt $(STAGING_DIR)/share/templates/
