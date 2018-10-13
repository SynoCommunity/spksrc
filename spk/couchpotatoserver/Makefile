SPK_NAME = couchpotatoserver
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 7
SPK_ICON = src/couchpotatoserver.png

DEPENDS =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = Diaoul
DESCRIPTION = CouchPotato is an automatic NZB and torrent downloader for movies. You can keep a \"want to watch\"-list and it will search for NZBs/torrents of these items every X hours. Once a correct release is found, matching the correct quality, it will send it to SABnzbd/NZBGet or download the .nzb or .torrent to a specified directory. The downloaded movie can then be automatically moved and renamed to your liking as well as indexed by your DiskStation.
DESCRIPTION_FRE = CouchPotato permet le téléchargement automatique de films via NZB ou torrent. Vous pouvez créer une \"liste de films à voir\", CouchPotato ira alors automatiquement rechercher les NZBs ou torrents correspondants toutes les X heures. Une fois qu\'une release correcte est trouvée, correspondant à la qualité demandé, elle sera ajouté a SABnzbd/NZBGet, ou téléchargée sous forme de .nzb ou de .torrent dans le répertoire indiqué. Les films téléchargés peuvent être déplacé et renommés selon vos préférences ainsi qu\'indexés par votre DiskStation.
DESCRIPTION_SPN = CouchPotato es un sistema automático de descarga de peliculas via NZB y torrent. Puedes tener una \"lista de películas para ver\" y el sistema buscará automáticamente cada X horas. Cuando el release es encotrado con la calidad que especificaste el sistema la enviará al programa de descargas SABnzbd/NZBGet/Transmision o descargá el .nzb o .torrent al directorio que especifiques. Cuando la pelicula se termine de descargar será movida y renombrada automaticamente a tu gusto, además de ser indexada por tu DiskStation.
RELOAD_UI = yes
DISPLAY_NAME = CouchPotato
CHANGELOG = "Integrate with DSM5+6 Generic Service support for correct permissions."

HOMEPAGE   = http://couchpota.to/
LICENSE    = GPL
STARTABLE = yes

WIZARDS_DIR      = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 5050
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

COPY_TARGET = nop
POST_STRIP_TARGET = couchpotatoserver_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: couchpotatoserver_extra_install
couchpotatoserver_extra_install: $(STAGING_DIR)/share/CouchPotatoServer
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/settings.conf $(STAGING_DIR)/var/settings.conf

$(STAGING_DIR)/share/CouchPotatoServer:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone --depth=1 https://github.com/CouchPotato/CouchPotatoServer.git CouchPotatoServer
