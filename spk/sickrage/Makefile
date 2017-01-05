SPK_NAME = sickrage
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/${SPK_NAME}.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = SynoCommunity
DESCRIPTION = Video File Manager for TV Shows. It watches for new episodes of your favorite shows and when they are posted it does its magic.
ADMIN_PORT = 8899
RELOAD_UI = yes
DISPLAY_NAME = SickRage
CHANGELOG =

HOMEPAGE   = http://sickrage.tv/
LICENSE    = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = sickrage_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: sickrage_extra_install
sickrage_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
