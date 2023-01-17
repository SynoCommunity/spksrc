SPK_NAME = pyload
SPK_VERS = 0.4.9
SPK_REV = 2
SPK_ICON = src/pyload.png
DSM_UI_DIR = app

BETA = 1

DEPENDS = cross/tesseract-ocr cross/tessdata-eng cross/js cross/$(SPK_NAME)
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = SynoCommunity
DESCRIPTION = pyLoad is a fast, lightweight and full featured download manager for many One-Click-Hoster, container formats like DLC, video sites or just plain http/ftp links.
ADMIN_PORT = 8190
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = pyLoad
CHANGELOG = Fix updatemanager

HOMEPAGE   = http://pyload.org
LICENSE    = GPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/
WIZARDS_DIR      = src/wizard/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = pyload_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: pyload_extra_install
pyload_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/pyload.conf $(STAGING_DIR)/etc/pyload.conf
	install -m 644 src/pyload_init.sql $(STAGING_DIR)/etc/pyload_init.sql
	install -m 644 src/htaccess.example $(STAGING_DIR)/etc/htaccess.example
	install -m 755 -d $(STAGING_DIR)/var
