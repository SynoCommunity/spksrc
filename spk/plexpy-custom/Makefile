SPK_NAME = plexpy-custom
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 7
SPK_ICON = src/plexpy-custom.png

DEPENDS =
SPK_DEPENDS = "python311>=3.11.4-7:git"

MAINTAINER = cytec
DESCRIPTION = PlexPy Custom allows you to run the fork of your choice of PlexPy. You will be asked for the fork\'s git URL during install.
DESCRIPTION_FRE = PlexPy Custom vous permet d\'exécuter la variante de PlexPy votre choix. Il vous sera demandé l\'URL git de la variante à l\'installation.
DISPLAY_NAME = PlexPy Custom
CHANGELOG = "1. Migrate to Python 3.11<br/>2. Change download URL to use https"

HOMEPAGE   = https://tautulli.com
LICENSE    = GPL
STARTABLE  = yes

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8010
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

COPY_TARGET = nop
POST_STRIP_TARGET = plexpy-custom_extra_install

# Pure Python package, make sure ARCH is noarch
override ARCH=noarch

include ../../mk/spksrc.spk.mk

.PHONY: plexpy-custom_extra_install
plexpy-custom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
