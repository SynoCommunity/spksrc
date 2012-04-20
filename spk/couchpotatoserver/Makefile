SPK_NAME = couchpotatoserver
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/couchpotatoserver.png
DSM_UI_DIR = app

DEPENDS  = cross/git
SPK_DEPENDS = "python>=2.7.2-1"

MAINTAINER = SynoCommunity
DESCRIPTION = CouchPotato Server is the new CouchPotato. It is an automatic NZB and torrent downloader for movies. You can keep a \"want to watch\"-list and it will search for NZBs/torrents of these items every X hours. Once a correct release is found, matching the correct quality, it will send it to SABnzbd/NZBGet or download the .nzb or .torrent to a specified directory. The downloaded movie can then be automatically moved and renamed to your liking as well as indexed by your DiskStation.
DESCRIPTION_FRE = CouchPotato Server est le nouveau CouchPotato. Il permet le téléchargement automatique de films via NZB ou torrent. Vous pouvez créer une \\\"liste de films à voir\\\", CouchPotato Server ira alors automatiquement rechercher les NZBs ou torrents correspondants toutes les X heures. Une fois qu\\\'une release correcte est trouvée, correspondant à la qualité demandé, elle sera ajouté a SABnzbd/NZBGet, ou téléchargée sous forme de .nzb ou de .torrent dans le répertoire indiqué. Les films téléchargés peuvent être déplacé et renommés selon vos préférences ainsi qu\\\'indexés par votre DiskStation.
ADMIN_PORT = 5050
RELOAD_UI = yes
DISPLAY_NAME = CouchPotato Server

HOMEPAGE   = http://couchpota.to/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

#COPY_TARGET = nop
POST_STRIP_TARGET = couchpotatoserver_extra_install

# Pure Python package, make sure ARCH is not defined
#override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: couchpotatoserver_extra_install
couchpotatoserver_extra_install: $(STAGING_DIR)/share/CouchPotatoServer
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/settings.conf $(STAGING_DIR)/var/settings.conf
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/couchpotatoserver.cgi.pl $(STAGING_DIR)/app/couchpotatoserver.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/CouchPotatoServer:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/RuudBurger/CouchPotatoServer.git CouchPotatoServer
#	rm -fr $(STAGING_DIR)/share/CouchPotatoServer/.git $(STAGING_DIR)/share/CouchPotatoServer/.gitignore

