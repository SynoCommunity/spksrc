SPK_NAME = sickchill
SPK_VERS = 20210329
SPK_REV = 16
SPK_ICON = src/sickchill.png

BUILD_DEPENDS = cross/python38 cross/poetry
# cross/cffi cross/setuptools cross/pip cross/wheel cross/cryptography
DEPENDS = cross/cryptography cross/PyNaCl cross/lxml cross/$(SPK_NAME)
SPK_DEPENDS = "python38:git"

WHEELS = src/requirements.txt

MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
DESCRIPTION_SPN = Gestor automático para bibliotecas de series. Busca nuevos episodios de tus series favoritas, y cuando son publicados hace su magia.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "Initial SickChill env fix and move to Python 3.8"

HOMEPAGE   = https://sickchill.github.io/
LICENSE    = GPLv3+

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
