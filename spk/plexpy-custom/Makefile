SPK_NAME = plexpy-custom
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
BETA = 1
SPK_ICON = src/plexpy-custom.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = cytec
DESCRIPTION = PlexPy Custom allows you to run the fork of your choice of PlexPy. You will be asked for the fork\'s git URL during install.
ADMIN_PORT = 8010
RELOAD_UI = yes
DISPLAY_NAME = PlexPy Custom
CHANGELOG = "Initial release"

HOMEPAGE   = https://github.com/JonnyWong16/plexpy
LICENSE    = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = plexpy-custom_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: plexpy-custom_extra_install
plexpy-custom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
