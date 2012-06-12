SPK_NAME = pyload
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/pyload.png
DSM_UI_DIR = app

DEPENDS  = cross/tesseract-ocr
SPK_DEPENDS = "python>=2.7.3-1"

MAINTAINER = SynoCommunity
DESCRIPTION = pyLoad is a fast, lightweight and full featured download manager for many One-Click-Hoster, container formats like DLC, video sites or just plain http/ftp links. It aims for low hardware requirements and platform independence to be runnable on all kind of systems \\\(desktop pc, netbook, NAS, router\\\). Despite its strict restriction it is packed full of features just like webinterface, captcha recognition, unrar and much more.
DESCRIPTION_FRE = pyLoad est un gestionnaire de téléchargement rapide, léger et très complet pour de nombreux One-Click-Hoster, un container comme DLC, les sites de vidéo ou simplement des http / ftp liens. Il a de faibles besoins en matériel et peut être executé sur tous les types de systèmes \\\(PC de bureau, netbook, NAS, routeur\\\). Il est bourré de fonctionnalités, tout comme l'interface web, la reconnaissance captcha, unrar et bien plus encore. 
DESCRIPTION_SPN = pyLoad es un gestor de descargas, rápido, ligero y muy completo para muchos One-Click-Hoster, un contenedor como DLC, los sitios de vídeo o simplemente enlaces http / ftp. Cuenta con bajos requerimientos de hardware y se puede ejecutar en todos los tipos de sistemas \\\(computadoras de escritorio, netbooks, NAS, router\\\). Se está repleto de características, como la interfaz web, reconocimiento de captcha, descomprimir y mucho más.

ADMIN_PORT = 8000
RELOAD_UI = yes
DISPLAY_NAME = pyLoad

HOMEPAGE   = http://pyload.org/
LICENSE    = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = pyload_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: pyload_extra_install
pyload_extra_install: $(STAGING_DIR)/share/pyLoad
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/pyloadconf/pyload.conf $(STAGING_DIR)/var/pyload.conf
	install -m 600 src/pyloadconf/accounts.conf $(STAGING_DIR)/var/accounts.conf
	install -m 600 src/pyloadconf/files.db $(STAGING_DIR)/var/files.db
	install -m 600 src/pyloadconf/files.version $(STAGING_DIR)/var/files.version
	install -m 600 src/pyloadconf/plugin.conf $(STAGING_DIR)/var/plugin.conf
	install -m 755 -d $(STAGING_DIR)/var/Logs
	install -m 755 -d $(STAGING_DIR)/var/scripts
	install -m 755 -d $(STAGING_DIR)/var/tmp
	install -m 755 -d $(STAGING_DIR)/var/userplugins
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/pyload.cgi.sh $(STAGING_DIR)/app/pyload.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/pyLoad:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && hg clone https://bitbucket.org/spoob/pyload pyLoad
	cd $(STAGING_DIR)/share/pyLoad && hg update stable
	rm -fr $(STAGING_DIR)/share/pyLoad/.hg $(STAGING_DIR)/share/pyLoad/.hgignore $(STAGING_DIR)/share/pyLoad/.hgtags
