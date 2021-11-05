SPK_NAME = sickchill
SPK_VERS = 20210729
SPK_REV = 3
SPK_ICON = src/sickchill.png

BUILD_DEPENDS = cross/python38 cross/setuptools cross/pip cross/wheel cross/poetry cross/lxml
# cross/cffi cross/setuptools cross/cryptography cross/poetry
DEPENDS = cross/PyNaCl cross/$(SPK_NAME)
SPK_DEPENDS = "python38"

WHEELS = src/requirements-cross.txt src/requirements.txt

MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "1. SickChill environment fix<br/>2. Move to Python 3.8 without git<br/>3. Added DSM7 Support"

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
