SPK_NAME = synodlnatrakt
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/synodlnatrakt.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git:MediaServer"


MAINTAINER = cytec
DESCRIPTION = SynoDLNAtrakt is the easyest way to scrobble watched TV-Shwos/Movies to trakt directly from your DiskStation.
DESCRIPTION_GER = SynoDLNAtrakt scrobbled Serien/Filme die über DLNA geschaut wurden direkt zu trakt.tv, ünterstützt den trakt 2Way-Sync und bietet ein einfaches Webinterface zur Ansicht der lokalen Datenbank.
DESCRIPTION_FRE = SynoDLNAtrakt est le meilleur moyen de suivi pour vos séries préférées sur trakt.tv, directement depuis votre DiskStation
ADMIN_PORT = 1337
RELOAD_UI = yes
DISPLAY_NAME = SynoDLNAtrakt

HOMEPAGE   = http://cytec.us/forum/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
COPY_TARGET = nop

POST_STRIP_TARGET = synodlnatrakt_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: synodlnatrakt_extra_install
synodlnatrakt_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/settings.conf $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/synodlnatrakt.cgi.py $(STAGING_DIR)/app/synodlnatrakt.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
