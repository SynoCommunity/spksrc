SPK_NAME = homeassistant
SPK_VERS = 0.118.5
SPK_REV = 12
SPK_ICON = src/${SPK_NAME}.png

SPK_DEPENDS = "python3>=3.8.6"

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/poetry
OPTIONAL_DEPENDS += cross/numpy

DEPENDS += cross/libyaml cross/bcrypt cross/cryptography
DEPENDS += cross/pillow
# for python-libnmap
DEPENDS += cross/nmap
# for mobile_app
DEPENDS += cross/PyNaCl

include ../../mk/spksrc.archs.mk

DEPENDS += cross/numpy

WHEELS = src/requirements.txt

MAINTAINER = ymartin59
DESCRIPTION = Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control.
DISPLAY_NAME = Home Assistant Core
CHANGELOG = "Upgraded Python 3.8. <br />Fix integrations: Xiaomi Gateway (Aqara), Xiaomi Miio, Sony PlayStation 4, IKEA TRÅDFRI, Apple iCloud, Minut Point"
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
