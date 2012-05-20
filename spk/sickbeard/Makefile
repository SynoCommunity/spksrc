SPK_NAME = sickbeard
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 2
SPK_ICON = src/sickbeard.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>=2.7.3-2"

MAINTAINER = SynoCommunity
DESCRIPTION = SickBeard is a PVR for newsgroup users \(with limited torrent support\). It watches for new episodes of your favorite shows and when they are posted it downloads them, sorts and renames them automatically. New episodes can also be indexed for your DiskStation.
DESCRIPTION_FRE = L\\\'application ultime pour télécharger et gérer vos séries TV via NZB ou torrent. Il surveille la sortie de nouveaux épisodes et les télécharge, classe, renomme automatiquement. Les nouveaux épisodes peuvent être indexés pour votre DiskStation.
DESCRIPTION_SPN = SickBeard es una aplicación para descargar series de televisión de manera automática. Busca por nuevos episodios de tus series favoritas y cuando estos están disponibles los descarga, ordena y renombra. Los nuevos episodios puedes ser indexados en tu DiskStation.
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
	install -m 755 src/app/sickbeard.cgi.py $(STAGING_DIR)/app/sickbeard.cgi
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

