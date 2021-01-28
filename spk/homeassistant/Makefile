SPK_NAME = homeassistant
SPK_VERS = 0.118.5
SPK_REV = 12
SPK_ICON = src/${SPK_NAME}.png

SPK_DEPENDS = "python3>=3.7.7"

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/poetry

DEPENDS += cross/libyaml cross/bcrypt cross/cryptography
DEPENDS += cross/pillow
# for iqvia
DEPENDS += cross/numpy

# for python-libnmap
DEPENDS += cross/nmap
# for mobile_app
DEPENDS += cross/PyNaCl

WHEELS = src/requirements.txt

MAINTAINER = ymartin59
DESCRIPTION = Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control.
DISPLAY_NAME = Home Assistant Core
CHANGELOG = "Added x64 iqvia support."
RELOAD_UI = yes
STARTABLE = yes

HOMEPAGE = https://www.home-assistant.io/
LICENSE  = Apache-2.0

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8123
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.spk.mk
