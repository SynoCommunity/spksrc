SPK_NAME = homeassistant
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 2
SPK_ICON = src/${SPK_NAME}.png

WHEELS = src/requirements.txt
PIP = pip3

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/pyephem cross/netifaces cross/psutil

SPK_DEPENDS = "python3>=3.4.1-4:git"

DEPENDS = cross/$(SPK_NAME) cross/busybox cross/nmap #for python-libnmap

MAINTAINER = SynoCommunity
DESCRIPTION = "Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control. The default password is empty, just click \"Login\".  Edit your settings via ssh in the configuration.yaml file. This is a beta package. Hue and Chrome are tested. Other modules might work, please test them and try to contribute if something does not work."
ADMIN_PORT = 8123
DISPLAY_NAME = Home Assistant
DSM_UI_DIR = app

BETA = 1
CHANGELOG = "Update to revision 785e5e0fe7b1989b5a8cb9c1622738d3e555442d. PyISY will now work without having the climate module installed."

HOMEPAGE   = https://home-assistant.io/
LICENSE    = MIT

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

UNSUPPORTED_ARCHS = powerpc ppc824x

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = homeassistant_extra_install

BUSYBOX_CONFIG = usrmng daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: homeassistant_extra_install
homeassistant_extra_install:
	install -m 755 -d ${STAGING_DIR}/share/wheelhouse
	install -m 644 ${WORK_DIR}/wheelhouse/* ${STAGING_DIR}/share/wheelhouse/
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
