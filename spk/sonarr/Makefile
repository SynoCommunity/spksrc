SPK_NAME = sonarr
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 5
SPK_ICON = src/sonarr.png

OPTIONAL_DEPENDS = cross/libstdc++
DEPENDS = cross/sonarr cross/sqlite

# Arch exclusions for dotnet 6.0
DOTNET_CORE_ARCHS = 1

MAINTAINER = SynoCommunity
MAINTAINER_URL = https://synocommunity.com/
DESCRIPTION = Sonarr is a PVR for newsgroup and torrent users. It can monitor multiple RSS feeds for new episodes of your favourite shows and will grab, sorts and rename them. It can also be configured to automatically upgrade the quality of files already downloaded if a better quality format becomes available.
DESCRIPTION_FRE = Sonarr est un PVR pour les utilisateurs de groupes de discussion et torrents. Il peut surveiller plusieurs flux RSS pour les nouveaux épisodes de vos séries préférées et saisira, sortes et les renomme. Il peut également être configuré pour mettre à jour automatiquement la qualité des fichiers déjà téléchargés si un meilleur format de qualité devient disponible.
DESCRIPTION_SPN = Sonarr es un PVR para los usuarios de grupos de noticias y torrents. Se puede controlar múltiples canales RSS para nuevos episodios de sus programas favoritos y se agarra, tipo y les cambia el nombre. También puede ser configurado para actualizar automáticamente la calidad de los archivos ya descargados si un formato de mejor calidad disponible.
CHANGELOG = "1. Update Sonarr to v4.0.10.2544."
DISPLAY_NAME = Sonarr v4
HOMEPAGE = https://sonarr.tv
LICENSE  = GPLv3
LICENSE_FILE = $(WORK_DIR)/Sonarr/LICENSE.md
HELPURL = https://wiki.servarr.com/sonarr/troubleshooting
SUPPORT_URL = https://wiki.servarr.com/sonarr/faq-v4

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8989
SERVICE_PORT_TITLE = Sonarr Web UI

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = sonarr_extra_install

# use alternate TMPDIR as /tmp might be too small and not accessible on DSM >= 7.1.
# TMPDIR is used for sonarr built in backup and update
USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
# dotnet requires libstdc++ version >= 6.0.22
DEPENDS += cross/libstdc++
endif

# replace previous legacy package
INSTALL_REPLACE_PACKAGES = "nzbdrone>=20210329-19"
USE_DEPRECATED_REPLACE_MECHANISM = yes
# disable checking for port conflicts
CHECKPORT = no

include ../../mk/spksrc.spk.mk

PACKAGE_VERSION = $(SPK_NAME_ARCH)-$(SPK_TCVERS)_$(SPK_VERS)-$(SPK_REV)
PACKAGE_AUTHOR = [SynoCommunity](https://synocommunity.com)

.PHONY: sonarr_extra_install
sonarr_extra_install:
	@$(MSG) "Install config.xml and provide package_info."
	@install -m 755 -d $(STAGING_DIR)/var/.config/Sonarr
	@install -m 644 src/config.xml $(STAGING_DIR)/var/.config/Sonarr/config.xml
	@echo "PackageVersion=$(PACKAGE_VERSION)\nPackageAuthor=$(PACKAGE_AUTHOR)" > $(STAGING_DIR)/share/Sonarr/package_info
