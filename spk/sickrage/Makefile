SPK_NAME = sickrage
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 5
SPK_ICON = src/${SPK_NAME}.png

SPK_DEPENDS = "python>=2.7.6-8:git"

MAINTAINER = echel0n
DESCRIPTION = Video File Manager for TV Shows. It watches for new episodes of your favorite shows and when they are posted it does its magic.
STARTABLE = yes
RELOAD_UI = yes
DISPLAY_NAME = SiCKRAGE
CHANGELOG = "Integrate with DSM5+6 Generic Service support for correct permissions."

HOMEPAGE   = https://www.sickrage.ca
LICENSE    = GPL

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8899
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

COPY_TARGET = nop
POST_STRIP_TARGET = sickrage_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: sickrage_extra_install
sickrage_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
