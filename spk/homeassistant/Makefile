SPK_NAME = homeassistant
SPK_VERS = 0.114.2
SPK_REV = 9
SPK_ICON = src/${SPK_NAME}.png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel cross/bcrypt
BUILD_DEPENDS += cross/poetry
DEPENDS = cross/nmap  # for python-libnmap
DEPENDS += cross/gmp cross/mpfr cross/mpc  # for gmpy2
DEPENDS += cross/libyaml cross/bcrypt cross/cryptography
DEPENDS += cross/PyNaCl # for mobile_app
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.7.7"

MAINTAINER = ymartin59
DESCRIPTION = Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control.
DISPLAY_NAME = Home Assistant
CHANGELOG = "1. Update to 0.114.2.<br/>2. Update openssl to 1.1.<br/>"
CHANGELOG += "3. Added missing core requirements<br/>"
CHANGELOG += "4. Added media_player.dlna_dmr requirements<br/>"
CHANGELOG += "5. Added device_tracker.upc_connect requirements<br/>"
CHANGELOG += "6. Added accuweather requirements<br/>"
CHANGELOG += "7. Added songpal requirements<br/>"
CHANGELOG += "8. Added syncthru requirements<br/>"
RELOAD_UI = yes
STARTABLE = yes

HOMEPAGE = https://www.home-assistant.io/
LICENSE  = Apache License 2.0

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8123
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
ADMIN_PORT = $(SERVICE_PORT)

# ppc archs except QorIQ
UNSUPPORTED_ARCHS = powerpc ppc824x ppc853x ppc854x

include ../../mk/spksrc.spk.mk
