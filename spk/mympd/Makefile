SPK_NAME = mympd
SPK_VERS = 26.1.1
SPK_REV = 4
SPK_ICON = src/mympd.png
DSM_UI_DIR = app

DEPENDS = cross/mympd

MAINTAINER = hgy59
DESCRIPTION = myMPD is a standalone and mobile friendly web mpd client with a tiny footprint and advanced features.
CHANGELOG = "1. Update myMPD to v26.1.1."

DISPLAY_NAME = myMPD

HOMEPAGE = https://jcorporation.github.io/
LICENSE = GPLv3

WIZARDS_DIR = src/wizard
SERVICE_WIZARD_SHARENAME = wizard_music_folder

# SERVICE_COMMAND is defined in service-setup.sh
STARTABLE = yes
SERVICE_PORT = 8185
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = mympd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: mympd_extra_install
mympd_extra_install:
	@$(MSG) Install default config folder
	@install -d -m 755 $(STAGING_DIR)/var
	@tar -cf - -C src config.default | tar -xf - -C $(STAGING_DIR)/var/
