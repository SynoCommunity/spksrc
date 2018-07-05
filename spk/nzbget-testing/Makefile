SPK_NAME = nzbget-testing
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 13
SPK_ICON = src/nzbget-testing.png

DEPENDS = cross/busybox cross/p7zip cross/unrar

BETA = 1

MAINTAINER = Safihre
DESCRIPTION = NZBGet is a command-line based binary newsgrabber for nzb files, written in C++. It supports client/server mode, automatic par-check/-repair, unpack and web-interface. NZBGet requires low system resources.
DESCRIPTION_FRE = NZBGet est un récupérateur de news en ligne de commande écrit en C++ pour les fichiers nzb. Il intègre un mode client/serveur, la vérification, réparation et décompression automatique ainsi qu\'une interface web. NZBGet requiert peu de ressources système.
DESCRIPTION_SPN = NZBGet es una aplicación de linea de comandos escrita en C++ para descargar binarios, desde servidores de noticias, utilizando archivos nzb. Soporta modo cliente y servidor, verificación y descompresión automática y una interfaz web. NZBGet utiliza pocos recursos de sistema.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = NZBGet Testing
CHANGELOG = "1) Use generic NZBGet installer, allows for in-app upgrading. 2) Use DSM 5+6 generic service approach for correct permissions."

HOMEPAGE = http://nzbget.net
LICENSE  = GPLv2

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 9876
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = nzbget_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: nzbget_extra_install
nzbget_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/share/nzbget/scripts
	# Include usefull scripts
	cd $(STAGING_DIR)/share/nzbget/scripts && git clone https://github.com/clinton-hall/nzbToMedia.git
	cd $(STAGING_DIR)/share/nzbget/scripts && git clone https://github.com/clinton-hall/GetScripts.git
