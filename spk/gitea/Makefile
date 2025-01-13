SPK_NAME = gitea
SPK_VERS = 1.23.1
SPK_REV = 18
SPK_ICON = src/gitea.png

MAINTAINER = wkobiela
DESCRIPTION  = Gitea is a community managed lightweight code hosting solution written in Go.
DISPLAY_NAME = Gitea
CHANGELOG = "1. Update to v1.23.1."

LICENSE = MIT

DEPENDS = cross/gitea
SPK_DEPENDS = "git>=2"

SERVICE_USER         		= auto
SERVICE_SETUP        		= src/service-setup.sh
STARTABLE            		= yes
WIZARDS_DIR          		= src/wizard/
SERVICE_WIZARD_SHARENAME 	= wizard_shared_folder_name

SERVICE_PORT = 8418
SERVICE_PORT_TITLE = $(DISPLAY_NAME) (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk

.PHONY: gitea_extra_install
gitea_extra_install:
	@$(MSG) "Install config.ini file"
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/config.ini $(STAGING_DIR)/var/config.ini