SPK_NAME = selfoss
SPK_VERS = 2.19
SPK_REV = 8
SPK_ICON = src/selfoss.png

DEPENDS  = cross/selfoss
# Pure PHP package, make sure ARCH is noarch
override ARCH=noarch

REQUIRED_MIN_DSM = 6.0
SPK_DEPENDS = WebStation:PHP7.4:Apache2.4

MAINTAINER = moneytoo
DESCRIPTION = The new multipurpose rss reader, live stream, mashup, aggregation web application.
DISPLAY_NAME = Selfoss
CHANGELOG = "1. Update Selfoss to 2.19.<br/>2. Use faster SQLite database."
HOMEPAGE   = https://selfoss.aditu.de/

LICENSE    = GPLv3

WIZARDS_DIR = src/wizard/

SYSTEM_GROUP = http

# Admin link for in DSM UI
ADMIN_URL = /selfoss/

DSM_UI_DIR = app
DSM_UI_CONFIG = src/app/config
CONF_DIR = src/conf/

# Set user as 'auto' for DSM 6 privilege
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = no

# TMPDIR is used for selfoss built in backup and update
USE_ALTERNATE_TMPDIR = 1

POST_STRIP_TARGET = selfoss_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: selfoss_extra_install
selfoss_extra_install:
	install -m 755 -d $(STAGING_DIR)/web
	install -m 644 src/web/selfoss.conf $(STAGING_DIR)/web/selfoss.conf
	install -m 644 src/web/selfoss.json $(STAGING_DIR)/web/selfoss.json
