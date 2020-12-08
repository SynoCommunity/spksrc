SPK_NAME = pyload
SPK_VERS = 0.4.20
SPK_REV = 4
SPK_ICON = src/pyload.png
DSM_UI_DIR = app

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = SynoCommunity
DESCRIPTION = pyLoad is a fast, lightweight and full featured download manager for many One-Click-Hoster, container formats like DLC, video sites or just plain http/ftp links.
RELOAD_UI = yes
DISPLAY_NAME = pyLoad
CHANGELOG = "1. Update to 0.4.20<br>2. Use generic service approach"

HOMEPAGE   = https://pyload.net/
LICENSE    = GPLv3

SERVICE_SETUP  = src/service-setup.sh
SSS_SCRIPT     = src/start-stop-status.sh
WIZARDS_DIR    = src/wizard/
SERVICE_USER   = auto
SERVICE_PORT	= 8190
ADMIN_PORT		= $(SERVICE_PORT)

POST_STRIP_TARGET = pyload_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: pyload_extra_install
pyload_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/pyload.conf $(STAGING_DIR)/var/pyload.conf
	install -m 644 src/pyload_init.sql $(STAGING_DIR)/var/pyload_init.sql
	install -m 644 src/htaccess.example $(STAGING_DIR)/var/htaccess.example
