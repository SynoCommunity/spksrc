SPK_NAME = mantisbt
SPK_VERS = 2.27.3
SPK_REV = 9
SPK_ICON = src/mantisbt.png

DEPENDS  = cross/mantisbt
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
# SRM is not supported due lacking webstation, php, mariadb and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = Mantis is an easily deployable, web based bugtracker to aid product bug tracking. It requires PHP, MySQL and a web server. It is simpler than Bugzilla and easily editable.
DESCRIPTION_FRE = Mantis est un bugtracker web aisément déployable pour faciliter le suivi des bogues. Il nécessite PHP, MySQL et un serveur web. Il est plus simple d\'accès que Bugzilla et facilement modifiable.
DISPLAY_NAME = MantisBT
CHANGELOG = "1. Update to v2.27.3.<br/>2. Adjust PHP dependency per DSM version."

HOMEPAGE   = https://www.mantisbt.org
LICENSE    = GPL

STARTABLE = no
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

ADMIN_URL = /mantisbt

WIZARDS_DIR = src/wizard/
SYSTEM_GROUP = http

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

include ../../mk/spksrc.common.mk

# Default to PHP 7.4 on DSM 6.x
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"
CONF_DIR = src/conf_6/

ifeq ($(call version_ge, ${TCVERSION}, 7.2),1)
# Use PHP 8.2 on DSM 7.2+ (PHP 8.0 not supported)
SPK_DEPENDS = "WebStation:PHP8.2:MariaDB10:Apache2.4"
CONF_DIR = src/conf_72/
else ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
# Use PHP 8.0 on DSM 7.0/7.1
SPK_DEPENDS = "WebStation:PHP8.0:MariaDB10:Apache2.4"
OS_MAX_VER = 7.1-59999
CONF_DIR = src/conf_7/
endif

POST_STRIP_TARGET = mantisbt_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mantisbt_extra_install
mantisbt_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/config_inc.php $(STAGING_DIR)/web/config_inc.php
	install -m 644 src/web/mantisbt.conf $(STAGING_DIR)/web/mantisbt.conf
	install -m 644 src/web/mantisbt.json $(STAGING_DIR)/web/mantisbt.json
