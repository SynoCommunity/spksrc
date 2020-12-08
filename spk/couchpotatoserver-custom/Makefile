SPK_NAME = couchpotatoserver-custom
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 6
SPK_ICON = src/couchpotatoserver-custom.png

DEPENDS =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = Diaoul
DESCRIPTION = CouchPotato Custom allows you to run the fork of your choice of CouchPotato. You will be asked for the fork\'s git URL during install.
DESCRIPTION_FRE = CouchPotato Custom vous permet d\'exécuter le fork de votre choix de CouchPotato. Vous aurez besoin de saisir l\'URL git du fork durant l\'installation.
RELOAD_UI = yes
DISPLAY_NAME = CouchPotato Custom
CHANGELOG = "Fix DSM 6 service start."

HOMEPAGE  = https://couchpota.to/
LICENSE   = GPL
STARTABLE = yes

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 5053
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

COPY_TARGET = nop
POST_STRIP_TARGET = couchpotatoserver-custom_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: couchpotatoserver-custom_extra_install
couchpotatoserver-custom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/settings.conf $(STAGING_DIR)/var/settings.conf
