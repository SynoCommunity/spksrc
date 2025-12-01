SPK_NAME = gitea
SPK_VERS = 1.25.0
SPK_REV = 26
SPK_ICON = src/gitea.png

MAINTAINER = wkobiela
DESCRIPTION  = Gitea is a community managed lightweight code hosting solution written in Go.
DISPLAY_NAME = Gitea
CHANGELOG = "1. Update to v1.25.0."

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

POST_STRIP_TARGET = gitea_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: gitea_extra_install
gitea_extra_install:
	@$(MSG) "Install conf.ini file"
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/conf.ini $(STAGING_DIR)/var/conf.ini
