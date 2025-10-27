SPK_NAME = openlist
SPK_VERS = 4.1.5
SPK_REV = 5
SPK_ICON = src/openlist.png

DEPENDS = cross/openlist

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)
# not supported by go:
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

MAINTAINER = GrandDuke1106
DESCRIPTION = A file list program that supports multiple storages, powered by Gin and SolidJS, fork of AList.
DISPLAY_NAME = OpenList
CHANGELOG = "1. Update to 4.1.5"

HOMEPAGE = https://docs.oplist.org/
LICENSE = AGPL-3.0

SERVICE_SETUP = src/service-setup.sh

STARTABLE = yes
SERVICE_USER = auto
SERVICE_PORT = 5244
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = openlist_extra_install

WIZARDS_TEMPLATES_DIR = src/wizard_templates

include ../../mk/spksrc.spk.mk

.PHONY: openlist_extra_install
openlist_extra_install:
	@$(MSG) Install default config file
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/config.json $(STAGING_DIR)/var/config.json
