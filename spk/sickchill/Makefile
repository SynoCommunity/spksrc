SPK_NAME = sickchill
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/sickchill.png

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "python3>=3.6:git"
PIP=pip3

WHEELS = src/requirements.txt

MAINTAINER = Nyaran
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
DESCRIPTION_SPN = Gestor automático para bibliotecas de series. Busca nuevos episodios de tus series favoritas, y cuando son publicados hace su magia.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "Initial SickChill version"

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

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: sickchill_extra_install
sickchill_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
