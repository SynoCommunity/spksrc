SPK_NAME = sickbeard
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/sickbeard.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>=2.7.2-1"

MAINTAINER = SynoCommunity
DESCRIPTION = SickBeard is the ultimate PVR application that downloads and manages your TV shows. It downloads in the quality you chose, rename, move and index episodes as soon as they are released
DESCRIPTION_FRE = SickBeard est l\\\'application ultime pour télécharger et gérer vos séries télévisées. Il télécharge dans la qualité désirée, renomme, déplace et indexe les épisodes dès leur sortie
ADMIN_PORT = 8081
RELOAD_UI = yes
DISPLAY_NAME = SickBeard

HOMEPAGE   = http://sickbeard.com/
LICENSE    = GPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = sickbeard_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: sickbeard_extra_install
sickbeard_extra_install: $(STAGING_DIR)/share/SickBeard
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/sickbeard.cgi.pl $(STAGING_DIR)/app/sickbeard.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/SickBeard:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/midgetspy/Sick-Beard.git SickBeard
	rm -fr $(STAGING_DIR)/share/SickBeard/.git $(STAGING_DIR)/share/SickBeard/.gitignore
	chmod 777 $(STAGING_DIR)/share/SickBeard/autoProcessTV
	install -m 600 $(STAGING_DIR)/share/SickBeard/autoProcessTV/autoProcessTV.cfg.sample $(STAGING_DIR)/share/SickBeard/autoProcessTV/autoProcessTV.cfg

