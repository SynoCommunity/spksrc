SPK_NAME = couchpotato
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/couchpotato.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>=2.7.2-1"

MAINTAINER = SynoCommunity
DESCRIPTION = CouchPotato is an automatic NZB and torrent downloader for movies. Many settings are available in the web interface like quality, renaming, folders, indexation, etc.
DESCRIPTION_FRE = CouchPotato permet de télécharger automatiquement de films via NZB ou torrent. De nombreuses options (qualité, renommage, dossiers, indexation, etc.) sont disponibles via l\\\'interface web.
ADMIN_PORT = 8200
RELOAD_UI = yes
DISPLAY_NAME = CouchPotato

HOMEPAGE   = http://couchpota.to/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = couchpotato_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: couchpotato_extra_install
couchpotato_extra_install: $(STAGING_DIR)/share/CouchPotato
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/couchpotato.cgi.pl $(STAGING_DIR)/app/couchpotato.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/CouchPotato:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/RuudBurger/CouchPotato.git CouchPotato
	rm -fr $(STAGING_DIR)/share/CouchPotato/.git $(STAGING_DIR)/share/CouchPotato/.gitignore

