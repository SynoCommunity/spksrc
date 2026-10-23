SPK_NAME = gitea
SPK_VERS = 28.2.0
SPK_REV = 32
SPK_ICON = src/gitea.png

MAINTAINER = wkobiela
DESCRIPTION  = Gitea is a community managed lightweight code hosting solution written in Go.
DISPLAY_NAME = Gitea
CHANGELOG = "Update to 28.2.0 (security fixes and bug fixes)."

LICENSE = MIT

DEPENDS = cross/gitea
SPK_DEPENDS = "git"

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes
WIZARDS_DIR = src/wizard/
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name

SERVICE_PORT = 8418
SERVICE_PORT_TITLE = gitea UI (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = gitea_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: gitea_extra_install
gitea_extra_install:
	@$(MSG) "Install conf.ini file"
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/conf.ini $(STAGING_DIR)/var/conf.ini
