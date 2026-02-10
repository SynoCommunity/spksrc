SPK_NAME = roundcube
SPK_VERS = 1.6.13
SPK_REV = 9
SPK_ICON = src/roundcube.png

DEPENDS  = cross/roundcube
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
# SRM is not supported due lacking webstation, php, mariadb and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = Roundcube is a free and open source webmail solution with a desktop-like user interface which is easy to install/configure and that runs on a standard LAMPP server. It is the same software Synology offers as Mail Station except this does not depend on Mail Server package.
DISPLAY_NAME = Roundcube Webmail
CHANGELOG = "Update to v1.6.13 with PHP 8.4 support for DSM 7.2+."

HOMEPAGE   = https://www.roundcube.net
LICENSE    = GPLv3

STARTABLE = no
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

ADMIN_URL = /roundcube/

WIZARDS_DIR = src/wizard/
SYSTEM_GROUP = http

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

include ../../mk/spksrc.common.mk

# DSM-specific PHP profiles
ifeq ($(call version_ge, ${TCVERSION}, 7.2),1)
SPK_DEPENDS = "WebStation:PHP8.4:MariaDB10:Apache2.4"
CONF_DIR = src/conf_72/
else ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
SPK_DEPENDS = "WebStation:PHP8.0:MariaDB10:Apache2.4"
OS_MAX_VER = 7.1-59999
CONF_DIR = src/conf_7/
else
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"
CONF_DIR = src/conf_6/
endif

ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
POST_STRIP_TARGET = roundcube_extra_install
endif

include ../../mk/spksrc.spk.mk

.PHONY: roundcube_extra_install
roundcube_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/roundcube.conf $(STAGING_DIR)/web/roundcube.conf
	install -m 644 src/web/roundcube.json $(STAGING_DIR)/web/roundcube.json
