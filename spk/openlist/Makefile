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

SERVICE_SETUP = src/service-setup.sh

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_PORT = 5244
SERVICE_PORT_TITLE = OpenList (HTTP)

SERVICE_COMMAND = bin/openlist server --data ${SYNOPKG_PKGDEST}/var
SVC_BACKGROUND = yes
SVC_WRITE_PID = yes

SPK_CONF_DIR = data

include ../../mk/spksrc.spk.mk

.PHONY: spk_install
spk_install:
	@$(MSG) "Creating installation directories"
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 -d $(STAGING_DIR)/var
	
	@$(MSG) "Installing OpenList binary"
	install -m 755 $(WORK_DIR)/$(PKG_DIR)/openlist $(STAGING_DIR)/bin/openlist
	
	@$(MSG) "Installing service scripts"
	install -m 755 -d $(STAGING_DIR)/scripts
	install -m 755 src/service-setup.sh $(STAGING_DIR)/scripts/