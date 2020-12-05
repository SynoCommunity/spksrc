SPK_NAME = homeassistant
SPK_VERS = 0.114.2
SPK_REV = 9
SPK_ICON = src/${SPK_NAME}.png

SPK_DEPENDS = "python3>=3.7.7"

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/poetry
OPTIONAL_DEPENDS += cross/numpy

DEPENDS += cross/cffi cross/libyaml cross/bcrypt cross/cryptography
# for python-libnmap
DEPENDS = cross/nmap
# for mobile_app
DEPENDS += cross/PyNaCl


include ../../mk/spksrc.common.mk

# unable to compile numpy 1.19.1 for x64 archs
ifneq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
# for iqvia
DEPENDS += cross/numpy
endif

WHEELS = src/requirements.txt

MAINTAINER = ymartin59
DESCRIPTION = Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control.
DISPLAY_NAME = Home Assistant
CHANGELOG = "1. Update Home Assistant to v0.114.2.<br/>2. Update openssl to 1.1.<br/>"
CHANGELOG += "3. Include all dependencies for core and cloud module.<br/>"
CHANGELOG += "4. Include all supported default integrations.<br/>"
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
