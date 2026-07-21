SPK_NAME = forgejo-lts
SPK_VERS = 15.0.4
SPK_REV = 1
SPK_ICON = src/forgejo.png

MAINTAINER = nhymxu
DESCRIPTION  = Forgejo is a self-hosted lightweight software forge. LTS version.
DISPLAY_NAME = Forgejo LTS
CHANGELOG = "1. Update to v15.0.4"

LICENSE = GPLv3

DEPENDS = cross/forgejo-lts
SPK_DEPENDS = "git>=2"

SERVICE_USER         		= auto
SERVICE_SETUP        		= src/service-setup.sh
STARTABLE            		= yes
WIZARDS_DIR          		= src/wizard/
SERVICE_WIZARD_SHARENAME 	= wizard_shared_folder_name

SERVICE_PORT = 8621
SERVICE_PORT_TITLE = $(DISPLAY_NAME) (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = forgejo_lts_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: forgejo_lts_extra_install
forgejo_lts_extra_install:
	@$(MSG) "Install conf.ini file"
	@install -m 755 -d $(STAGING_DIR)/var
	@install -m 644 src/conf.ini $(STAGING_DIR)/var/conf.ini
