SPK_NAME = nextcloud
SPK_VERS = 32.0.5
SPK_REV = 2
SPK_ICON = src/nextcloud.png

DEPENDS =
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 7.2
CONF_DIR = src/conf_72
SPK_DEPENDS = WebStation:PHP8.3:MariaDB10:Apache2.4:redis

# SRM is not supported due lacking webstation, php, mariadb and apache packages
REQUIRED_MIN_SRM = 3.0

MAINTAINER = SynoCommunity
DESCRIPTION = Nextcloud is a self-hosted productivity platform giving you control over your data with web, desktop and mobile access.
DISPLAY_NAME = Nextcloud
CHANGELOG = "Update to v32.0.5."
HOMEPAGE = https://nextcloud.com/

LICENSE = AGPLv3
LICENSE_FILE = src/COPYING

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

PRE_COPY_TARGET = nextcloud_install
PLIST_TRANSFORM = sed 's,^target/,,'

include ../../mk/spksrc.spk.mk

.PHONY: nextcloud_install
nextcloud_install:
	install -d -m 755 "$(INSTALL_DIR)/var/packages/$(SPK_NAME)/target/share/nextcloud"
	install -m 644 "src/COPYING" "$(INSTALL_DIR)/var/packages/$(SPK_NAME)/target/share/nextcloud/COPYING"
	install -m 644 "src/README" "$(INSTALL_DIR)/var/packages/$(SPK_NAME)/target/share/nextcloud/README"
