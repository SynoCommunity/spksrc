SPK_NAME = icingaweb2
SPK_VERS = 2.12.6
SPK_REV = 1
SPK_ICON = src/icingaweb2.png

DEPENDS  = cross/icingaweb2
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 7.1

MAINTAINER = SynoCommunity
DESCRIPTION = Icinga Web 2 is a powerful PHP framework for web applications that provides the frontend for Icinga 2 monitoring.
DISPLAY_NAME = Icinga Web 2
CHANGELOG = "Initial release of Icinga Web 2 v2.12.6"

HOMEPAGE = https://icinga.com/
LICENSE = GPLv2

WIZARDS_TEMPLATES_DIR = src/wizard_templates

SYSTEM_GROUP = http

ADMIN_URL = /icingaweb2/

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

include ../../mk/spksrc.common.mk

# DSM 7.2+: Use PHP 8.2
ifeq ($(call version_ge, ${TCVERSION}, 7.2),1)
SPK_DEPENDS = "WebStation:PHP8.2:Apache2.4:MariaDB10"
CONF_DIR = src/conf_72/
else ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
# DSM 7.0/7.1: Use PHP 8.0
SPK_DEPENDS = "WebStation:PHP8.0:Apache2.4:MariaDB10"
OS_MAX_VER = 7.1-59999
CONF_DIR = src/conf_7/
endif

POST_STRIP_TARGET = icingaweb2_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: icingaweb2_extra_install
icingaweb2_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 755 -d $(STAGING_DIR)/share/templates/modules/monitoring
	install -m 644 src/templates/*.ini $(STAGING_DIR)/share/templates/
	install -m 644 src/templates/modules/monitoring/*.ini $(STAGING_DIR)/share/templates/modules/monitoring/
	# Install custom index.php wrapper for environment variables
	install -m 644 src/index.php $(STAGING_DIR)/share/icingaweb2/public/index.php
	# Install .htaccess for URL rewriting
	install -m 644 src/htaccess $(STAGING_DIR)/share/icingaweb2/public/.htaccess
	# Install PHP script for creating admin user programmatically
	install -m 755 src/create-admin.php $(STAGING_DIR)/share/create-admin.php
