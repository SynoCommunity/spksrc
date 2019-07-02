SPK_NAME = sickbeard-custom
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 7
SPK_ICON = src/sickbeard-custom.png

SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = Diaoul
DESCRIPTION = SickBeard Custom allows you to run the fork of your choice of SickBeard. You will be asked for the fork\'s git URL during install.
DESCRIPTION_FRE = SickBeard Custom vous permet d\'exécuter la variante de votre choix de SickBeard. Vous aurez besoin de saisir l\'URL git de la variante à l\'installation.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = SickBeard Custom
CHANGELOG = "Integrate with DSM5+6 Generic Service support for correct permissions."

HOMEPAGE   = http://sickbeard.com
LICENSE    = GPL
HELPURL    = https://github.com/SynoCommunity/spksrc/wiki/FAQ-SickBeard-custom

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8083
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

COPY_TARGET = nop
POST_STRIP_TARGET = sickbeard-custom_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: sickbeard-custom_extra_install
sickbeard-custom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
