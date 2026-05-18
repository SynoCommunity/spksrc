SPK_NAME = roundcube
SPK_VERS = 1.7.0
SPK_REV = 10
SPK_ICON = src/roundcube.png

DEPENDS  = cross/roundcube
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Requires PHP 8.1+ (Roundcube 1.7)
REQUIRED_MIN_DSM = 7.2
# SRM is not supported due lacking webstation, php, mariadb and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = Roundcube is a free and open source webmail solution with a desktop-like user interface which is easy to install/configure and that runs on a standard LAMPP server. It is the same software Synology offers as Mail Station except this does not depend on Mail Server package.
DISPLAY_NAME = Roundcube Webmail
CHANGELOG = "Update to v1.7.0. Drop DSM &lt; 7.2 (requires PHP 8.1+)."

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

# Roundcube 1.7 requires PHP 8.1+
SPK_DEPENDS = "WebStation:PHP8.4:MariaDB10:Apache2.4"
CONF_DIR = src/conf/

POST_STRIP_TARGET = roundcube_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: roundcube_extra_install
roundcube_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/db_update.php $(STAGING_DIR)/bin/db_update.php
