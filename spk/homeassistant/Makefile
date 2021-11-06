SPK_NAME = homeassistant
SPK_VERS = 2021.9.7
SPK_REV = 15
SPK_ICON = src/${SPK_NAME}.png

SPK_DEPENDS = "python38"

BUILD_DEPENDS = cross/python38 cross/setuptools cross/pip cross/wheel

DEPENDS += cross/libyaml cross/bcrypt cross/cryptography cross/pycrypto cross/pycryptodomex cross/pycryptodome
DEPENDS += cross/gevent
DEPENDS += cross/homeassistant.pillow
# for iqvia
DEPENDS += cross/numpy
# for python-libnmap
DEPENDS += cross/nmap
# for mobile_app
DEPENDS += cross/PyNaCl
# for tradfri
DEPENDS += cross/dtlssocket
# for denonavr
DEPENDS += cross/asyncstdlib
# for flunearyou
DEPENDS += cross/ujson

# Include cross compiled wheels only, the package installer downloads pure python wheels at installation time.
WHEELS = src/requirements-cross.txt

MAINTAINER = hgy59
DESCRIPTION = "Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control."
DISPLAY_NAME = Home Assistant Core
CHANGELOG = "Update homeassistant to 2021.9.7.<br/>Only arch specific python modules are included in the package. Other modules are downloaded at installation time."
STARTABLE = yes

HOMEPAGE = https://www.home-assistant.io/
LICENSE  = Apache-2.0

WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8123
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
ADMIN_PORT = $(SERVICE_PORT)

USE_ALTERNATE_TMPDIR = 1

POST_STRIP_TARGET = homeassistant_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: homeassistant_extra_install
homeassistant_extra_install:
	@install -m 755 -d $(STAGING_DIR)/share
	@install -m 644 src/postinst_default_config_requirements.txt $(STAGING_DIR)/share/
	@install -m 644 src/postinst_components_requirements.txt $(STAGING_DIR)/share/
