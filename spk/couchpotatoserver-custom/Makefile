SPK_NAME = couchpotatoserver-custom
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 5
SPK_ICON = src/couchpotatoserver-custom.png

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = Diaoul
DESCRIPTION = CouchPotato Custom allows you to run the fork of your choice of CouchPotato. You will be asked for the fork\'s git URL during install.
DESCRIPTION_FRE = CouchPotato Custom vous permet d\'exécuter le fork de votre choix de CouchPotato. Vous aurez besoin de saisir l\'URL git du fork durant l\'installation.
RELOAD_UI = yes
DISPLAY_NAME = CouchPotato Custom
CHANGELOG = "Integrate with DSM5+6 Generic Service support for correct permissions."

HOMEPAGE   = http://couchpota.to/
LICENSE    = GPL
STARTABLE = yes

WIZARDS_DIR      = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 5053
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

COPY_TARGET = nop
POST_STRIP_TARGET = couchpotatoservercustom_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: couchpotatoservercustom_extra_install
couchpotatoservercustom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/settings.conf $(STAGING_DIR)/var/settings.conf
