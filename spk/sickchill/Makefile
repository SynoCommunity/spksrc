SPK_NAME = sickchill
SPK_VERS = $(shell date +%Y.%m.%d)
SPK_REV = 2
SPK_ICON = src/sickchill.png

BUILD_DEPENDS = cross/python38
# python38 includes the other depends cross/cryptography cross/lxml cross/cffi cross/sqlite
DEPENDS += cross/PyNaCl cross/mediainfo cross/poetry

SPK_DEPENDS = "python38"
PIP=pip3

WHEELS = src/requirements.txt

MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
DESCRIPTION_SPN = Gestor automático para bibliotecas de series. Busca nuevos episodios de tus series favoritas, y cuando son publicados hace su magia.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "SickChill updated for DSM7 with proper wheels"

HOMEPAGE   = https://sickchill.github.io/
LICENSE    = GPL

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8081
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

POST_STRIP_TARGET = sickchill_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: sickchill_extra_install
sickchill_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
