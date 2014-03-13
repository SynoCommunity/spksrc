SPK_NAME = nzbdrone
SPK_VERS = 2.0.0.1236
SPK_REV = 1
SPK_ICON = src/nzbdrone.png

DEPENDS = cross/busybox

SPK_DEPENDS = "Mono>2.11.1:mediainfo>0.7.61"

MAINTAINER = SynoCommunity

DESCRIPTION = NZBDrone is a PVR for newsgroup users. It can monitor multiple RSS feeds for new episodes of your favourite shows and will grab, sorts and renames them. It can also be configured to automatically upgrade the quality of files already downloaded if a better quality format becomes available.
DESCRIPTION_FRE = NZBDrone est un PVR pour les utilisateurs de groupes de discussion. Il peut surveiller plusieurs flux RSS pour les nouveaux épisodes de vos séries préférées et saisira, sortes et les renomme. Il peut également être configuré pour mettre à jour automatiquement la qualité des fichiers déjà téléchargés si un meilleur format de qualité devient disponible.
DESCRIPTION_SPN = NZBDrone es un PVR para los usuarios de grupos de noticias. Se puede controlar múltiples canales RSS para nuevos episodios de sus programas favoritos y se agarra, tipo y les cambia el nombre. También puede ser configurado para actualizar automáticamente la calidad de los archivos ya descargados si un formato de mejor calidad disponible.
ADMIN_PORT = 8989
RELOAD_UI = yes
DISPLAY_NAME = NzbDrone
CHANGELOG = "1. Initial package"

HOMEPAGE = http://nzbdrone.com/
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = nzbdrone_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: nzbdrone_extra_install
nzbdrone_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
