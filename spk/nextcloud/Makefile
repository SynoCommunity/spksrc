SPK_NAME = nextcloud
SPK_VERS = 32.0.2
SPK_REV = 1
SPK_ICON = src/nextcloud.png

DEPENDS = cross/nextcloud
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 7.2
CONF_DIR = src/conf_72
SPK_DEPENDS = WebStation:PHP8.2:MariaDB10:Apache2.4:redis

# SRM is not supported due lacking webstation, php, mariadb and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = Nextcloud is a self-hosted productivity platform giving you control over your data with web, desktop and mobile access.
DISPLAY_NAME = Nextcloud
CHANGELOG = "Initial packaging for Nextcloud 32.0.2."
HOMEPAGE = https://nextcloud.com/

LICENSE = AGPLv3
LICENSE_FILE = $(WORK_DIR)/nextcloud/COPYING

WIZARDS_TEMPLATES_DIR = src/wizard_templates
SERVICE_WIZARD_SHARENAME = wizard_data_share

SYSTEM_GROUP = http

# Admin link for in DSM UI
ADMIN_URL = /nextcloud/
ADMIN_PROTOCOL = https

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config

SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes
SERVICE_USER = auto

# TMPDIR is used for nextcloud built in backup and update
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk
