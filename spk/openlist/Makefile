SPK_NAME = openlist
SPK_VERS = 4.0.3
SPK_REV = 1
SPK_ICON = src/openlist.png

DEPENDS = cross/openlist

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)
# not supported by go:
UNSUPPORTED_ARCHS += $(PPC_ARCHS)

MAINTAINER = GrandDuke1106
DESCRIPTION = A file list program that supports multiple storages, powered by Gin and SolidJS, fork of AList.
DISPLAY_NAME = OpenList
CHANGELOG = "Initial package release."

HOMEPAGE = https://docs.oplist.org/
LICENSE = AGPL-3.0

SERVICE_SETUP = src/service-setup.sh

STARTABLE = yes
SERVICE_USER = auto
SERVICE_PORT = 5244
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = openlist_extra_install

# TODO: add installation to define admin password
#WIZARDS_DIR = src/wizard

include ../../mk/spksrc.spk.mk

.PHONY: openlist_extra_install
openlist_extra_install:
	@$(MSG) Install default config file
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/config.json $(STAGING_DIR)/var/config.json
