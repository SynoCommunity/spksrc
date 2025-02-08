SPK_NAME = roundcube
SPK_VERS = 1.6.9
SPK_REV = 5
SPK_ICON = src/roundcube.png

DEPENDS  = cross/roundcube
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"

MAINTAINER = SynoCommunity
DESCRIPTION = Roundcube is a free and open source webmail solution with a desktop-like user interface which is easy to install/configure and that runs on a standard LAMPP server. It is the same software Synology offers as Mail Station except this does not depend on Mail Server package.
DISPLAY_NAME = Roundcube Webmail
CHANGELOG = "1. Update to v1.6.9.<br/>2. Add PHP profiles for DSM 6.<br/>3. Add backup and restore functions."

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
CONF_DIR = src/conf/

include ../../mk/spksrc.common.mk

# Alternate conf dir for DSM 6
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
CONF_DIR = src/conf_6/
endif

POST_STRIP_TARGET = roundcube_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: roundcube_extra_install
roundcube_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/roundcube.conf $(STAGING_DIR)/web/roundcube.conf
	install -m 644 src/web/roundcube.json $(STAGING_DIR)/web/roundcube.json
