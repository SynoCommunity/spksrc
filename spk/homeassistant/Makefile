SPK_NAME = homeassistant
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/${SPK_NAME}.png
DSM_UI_DIR = app

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS = cross/busybox cross/nmap #for python-libnmap
WHEELS = src/requirements.txt
SPK_DEPENDS = "python3>=3.4.1-4:git"

MAINTAINER = SynoCommunity
DESCRIPTION = Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control.
ADMIN_PORT = 8123
DISPLAY_NAME = Home Assistant
CHANGELOG = "First release"

BETA = 1

HOMEPAGE = https://home-assistant.io/
LICENSE  = MIT

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
homeassistant_extra_install: $(STAGING_DIR)/share/homeassistant
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config

$(STAGING_DIR)/share/homeassistant:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone --recursive https://github.com/balloob/home-assistant.git homeassistant
	rm -fr $(STAGING_DIR)/share/homeassistant/.git $(STAGING_DIR)/share/homeassistant/.gitignore
