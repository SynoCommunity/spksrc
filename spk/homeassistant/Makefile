SPK_NAME = homeassistant
SPK_VERS = 0.87.1
SPK_REV = 3
SPK_ICON = src/${SPK_NAME}.png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS = cross/cffi cross/nmap  # for python-libnmap
DEPENDS += cross/gmp cross/mpfr cross/mpc  # for gmpy2
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.6.8"

MAINTAINER = ymartin59
DESCRIPTION = Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control.
DISPLAY_NAME = Home Assistant
CHANGELOG = "1. Update to 0.87.1<br/>2. Support for DSM 6"
RELOAD_UI = yes
STARTABLE = yes

BETA = 1

HOMEPAGE = https://www.home-assistant.io/
LICENSE  = Apache License 2.0

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8123
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
ADMIN_PORT = $(SERVICE_PORT)

UNSUPPORTED_ARCHS = $(PPC_ARCHES)

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

include ../../mk/spksrc.spk.mk
