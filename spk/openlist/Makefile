SPK_NAME = openlist
SPK_VERS = 4.0.3
SPK_REV = 1

DESCRIPTION = A file list program that supports multiple storages, powered by Gin and SolidJS, fork of AList.
MAINTAINER = gao
SPK_LICENSE = AGPL-3.0
DISPLAY_NAME = OpenList
CHANGELOG = "init v4.0.3."
SPK_ICON = src/logo.png

DEPENDS = cross/openlist

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
ADMIN_PROTOCOL = http
ADMIN_PORT = 5244

POST_STRIP_TARGET = openlist_extra_install

#WIZARDS_DIR = src/wizard

include ../../mk/spksrc.spk.mk

# Copy additional files
.PHONY: openlist_extra_install
openlist_extra_install:
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/config.json.template $(STAGING_DIR)/var/config.json.template