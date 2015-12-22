SPK_NAME = nzbdrone
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 8
SPK_ICON = src/sonarr.png
DSM_UI_DIR = app

REQUIRED_DSM = 5.0
UNSUPPORTED_ARCHS = $(PPC_ARCHES)

DEPENDS = cross/busybox cross/curl cross/mediainfo cross/sqlite cross/sonarr

SPK_DEPENDS = "mono>3.6"

MAINTAINER = SynoCommunity

DESCRIPTION = Sonarr is a PVR for newsgroup users. It can monitor multiple RSS feeds for new episodes of your favourite shows and will grab, sorts and rename them. It can also be configured to automatically upgrade the quality of files already downloaded if a better quality format becomes available.
DESCRIPTION_FRE = Sonarr est un PVR pour les utilisateurs de groupes de discussion. Il peut surveiller plusieurs flux RSS pour les nouveaux épisodes de vos séries préférées et saisira, sortes et les renomme. Il peut également être configuré pour mettre à jour automatiquement la qualité des fichiers déjà téléchargés si un meilleur format de qualité devient disponible.
DESCRIPTION_SPN = Sonarr es un PVR para los usuarios de grupos de noticias. Se puede controlar múltiples canales RSS para nuevos episodios de sus programas favoritos y se agarra, tipo y les cambia el nombre. También puede ser configurado para actualizar automáticamente la calidad de los archivos ya descargados si un formato de mejor calidad disponible.
ADMIN_PORT = 8989
RELOAD_UI = yes
DISPLAY_NAME = Sonarr
CHANGELOG = "Fix curl/ssl issue on 64bit models"

HOMEPAGE = https://sonarr.tv
LICENSE  = GPLv3

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/$(SPK_NAME).sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = sonarr_extra_install

BUSYBOX_CONFIG = usrmng daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: sonarr_extra_install
sonarr_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/.config
	install -m 755 -d $(STAGING_DIR)/var/.config/NzbDrone
	install -m 644 src/config.xml $(STAGING_DIR)/var/.config/NzbDrone/config.xml
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
