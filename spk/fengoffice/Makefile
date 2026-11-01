SPK_NAME = fengoffice
SPK_VERS = 4.2.0.3
SPK_REV = 11
SPK_ICON = src/fengoffice.png

DEPENDS = cross/fengoffice
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Requires PHP 8.2+. PHP 8.3 is used because PHP 8.4 no longer ships the imap extension.
REQUIRED_MIN_DSM = 7.2
# SRM is not supported due lacking webstation, php, mariadb and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = Feng Office is a Collaboration Platform and Project Management System.
DISPLAY_NAME = Feng Office
CHANGELOG = "Update to v4.2.0.3 (PHP 8.3, DSM 7.2+)."

HOMEPAGE = https://www.fengoffice.com/
LICENSE = AGPL

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

ADMIN_URL = /fengoffice/

WIZARDS_DIR = src/wizard/
SYSTEM_GROUP = http

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

SPK_DEPENDS = "WebStation:PHP8.3:MariaDB10:Apache2.4"
CONF_DIR = src/conf/

include ../../mk/spksrc.spk.mk
