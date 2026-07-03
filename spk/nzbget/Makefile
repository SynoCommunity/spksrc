SPK_NAME = nzbget
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 30
SPK_ICON = src/nzbget.png

MAINTAINER = SynoCommunity
DESCRIPTION = NZBGet is a command-line based binary newsgrabber for nzb files, written in C++. It supports client/server mode, automatic par-check/-repair, unpack and web-interface. NZBGet requires low system resources.
DESCRIPTION_FRE = NZBGet est un récupérateur de news en ligne de commande écrit en C++ pour les fichiers nzb. Il intègre un mode client/serveur, la vérification, réparation et décompression automatique ainsi qu\'une interface web. NZBGet requiert peu de ressources système.
DESCRIPTION_SPN = NZBGet es una aplicación de linea de comandos escrita en C++ para descargar binarios, desde servidores de noticias, utilizando archivos nzb. Soporta modo cliente y servidor, verificación y descompresión automática y una interfaz web. NZBGet utiliza pocos recursos de sistema.
STARTABLE = yes
DISPLAY_NAME = NZBGet
CHANGELOG = "Switch package to nzbgetcom (https://nzbget.com) version"

HOMEPAGE = https://nzbget.com
LICENSE  = GPLv2

WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_download_folder
USE_DATA_SHARE_WORKER = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 6789
SERVICE_PORT_TITLE = NZBGet (HTTP)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

# Installer brings all the binaries
COPY_TARGET = nop
override ARCH=noarch

POST_STRIP_TARGET = nzbget_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: nzbget_extra_install
nzbget_extra_install:
	install -m 755 -d $(STAGING_DIR)/var $(STAGING_DIR)/share/nzbget/scripts
	# Include usefull scripts
	cd $(STAGING_DIR)/share/nzbget/scripts && git clone --depth=1 https://github.com/clinton-hall/nzbToMedia.git
	cd $(STAGING_DIR)/share/nzbget/scripts && git clone --depth=1 https://github.com/clinton-hall/GetScripts.git
