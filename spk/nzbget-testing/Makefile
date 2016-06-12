SPK_NAME = nzbget-testing
SPK_VERS = 16.0~r1439
SPK_REV = 11
SPK_ICON = src/nzbget-testing.png
DSM_UI_DIR = app

DEPENDS = cross/busybox cross/p7zip cross/unrar cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = NZBGet is a command-line based binary newsgrabber for nzb files, written in C++. It supports client/server mode, automatic par-check/-repair, unpack and web-interface. NZBGet requires low system resources.
DESCRIPTION_FRE = NZBGet est un récupérateur de news en ligne de commande écrit en C++ pour les fichiers nzb. Il intègre un mode client/serveur, la vérification, réparation et décompression automatique ainsi qu\\\'une interface web. NZBGet requiert peu de ressources système.
DESCRIPTION_SPN = NZBGet es una aplicación de linea de comandos escrita en C++ para descargar binarios, desde servidores de noticias, utilizando archivos nzb. Soporta modo cliente y servidor, verificación y descompresión automática y una interfaz web. NZBGet utiliza pocos recursos de sistema.
RELOAD_UI = yes
ADMIN_PORT = 9876
DISPLAY_NAME = NZBGet Testing
CHANGELOG = "1. Update to 16.0~r1439<br>2. Security fix for p7zip"
BETA = 1

HOMEPAGE = http://nzbget.net
LICENSE  = GPLv2

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = nzbget_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: nzbget_extra_install
nzbget_extra_install: $(STAGING_DIR)/share/nzbget/scripts/nzbToMedia $(STAGING_DIR)/share/nzbget/scripts/GetScripts
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/nzbget.conf $(STAGING_DIR)/var/nzbget.conf
	install -m 644 src/nzbget.conf.template $(STAGING_DIR)/share/nzbget/nzbget.conf
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/texts
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/nzbget/scripts/nzbToMedia:
	cd $(STAGING_DIR)/share/nzbget/scripts && git clone https://github.com/clinton-hall/nzbToMedia.git

$(STAGING_DIR)/share/nzbget/scripts/GetScripts:
	cd $(STAGING_DIR)/share/nzbget/scripts && git clone https://github.com/clinton-hall/GetScripts.git
