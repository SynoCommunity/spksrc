SPK_NAME = nzbget
SPK_VERS = 9.0~r462
SPK_REV = 4
SPK_ICON = src/nzbget.png
DSM_UI_DIR = app
CHANGELOG = "1. Uninstallation required"
BETA = 1

DEPENDS = cross/busybox cross/unrar cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION     = NZBGet is a command-line based binary newsgrabber for nzb files, written in C++. It supports client/server mode, automatic par-check/-repair, unpack and web-interface. NZBGet requires low system resources.
DESCRIPTION_FRE = NZBGet est un récupérateur de news en ligne de commande écrit en C++ pour les fichiers nzb. Il intègre un mode client/serveur, la vérification, réparation et décompression automatique ainsi qu\\\'une interface web. NZBGet requiert peu de ressources système.
DESCRIPTION_SPN = NZBGet es una aplicación de linea de comandos escrita en C++ para descargar binarios, desde servidores de noticias, utilizando archivos nzb. Soporta modo cliente y servidor, verificación y descompresión automática y una interfaz web. NZBGet utiliza pocos recursos de sistema.
RELOAD_UI = yes
DISPLAY_NAME = NZBGet
ADMIN_PORT = 6789

HOMEPAGE = http://nzbget.sourceforge.net/
LICENSE  =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = nzbget_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: nzbget_extra_install
nzbget_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/nzbget.conf $(STAGING_DIR)/var/nzbget.conf
	install -m 755 src/nzbget-postprocess.sh $(STAGING_DIR)/bin/nzbget-postprocess.sh
	install -m 644 src/nzbget-postprocess.conf $(STAGING_DIR)/var/nzbget-postprocess.conf
	install -m 644 src/nzbget-postprocess.conf $(STAGING_DIR)/share/nzbget/webui/nzbget-postprocess.conf
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/nzbget.cgi.pl $(STAGING_DIR)/app/nzbget.cgi
	install -m 755 -d $(STAGING_DIR)/app/texts
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

