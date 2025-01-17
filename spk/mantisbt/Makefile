SPK_NAME = mantisbt
SPK_VERS = 2.27.0
SPK_REV = 7
SPK_ICON = src/mantisbt.png

DEPENDS  = cross/mantisbt
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

# Due to not obvious WebStation handling requirements
REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = "WebStation:PHP7.4:MariaDB10:Apache2.4"

MAINTAINER = SynoCommunity
DESCRIPTION = Mantis is an easily deployable, web based bugtracker to aid product bug tracking. It requires PHP, MySQL and a web server. It is simpler than Bugzilla and easily editable.
DESCRIPTION_FRE = Mantis est un bugtracker web aisément déployable pour faciliter le suivi des bogues. Il nécessite PHP, MySQL et un serveur web. Il est plus simple d\'accès que Bugzilla et facilement modifiable.
DISPLAY_NAME = MantisBT
CHANGELOG = "1. Update to v2.27.0."

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
CONF_DIR = src/conf/

include ../../mk/spksrc.common.mk

# Alternate conf dir for DSM 6
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
CONF_DIR = src/conf_6/
endif

POST_STRIP_TARGET = mantisbt_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mantisbt_extra_install
mantisbt_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/config_inc.php $(STAGING_DIR)/web/config_inc.php
	install -m 644 src/web/mantisbt.conf $(STAGING_DIR)/web/mantisbt.conf
	install -m 644 src/web/mantisbt.json $(STAGING_DIR)/web/mantisbt.json
