SPK_NAME = mympd
SPK_VERS = 14.1.0
SPK_REV = 2
SPK_ICON = src/mympd.png
DSM_UI_DIR = app

DEPENDS = cross/mympd

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

MAINTAINER = hgy59
DESCRIPTION = myMPD is a standalone and mobile friendly web mpd client with a tiny footprint and advanced features.
CHANGELOG = "Initial package release."

DISPLAY_NAME = myMPD

HOMEPAGE = https://jcorporation.github.io/
LICENSE = GPLv3

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
