SPK_NAME = hassio
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png
SPK_DEPENDS = Docker
DSM_UI_DIR = app

DEPENDS = cross/busybox

MAINTAINER = fredrike+hassio@gmail.com
DESCRIPTION = "Open source home automation that puts local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts. Note: identified USB devices will be added to the file usb_devices.txt located in the hass.io folder."
ADMIN_PORT = 8123
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Hass.io
CHANGELOG = ""

UNSUPPORTED_ARCHS = $(ARM_ARCHES) $(PPC_ARCHES) $(x86_ARCHES)

HOMEPAGE   = https://www.home-assistant.io/hassio/
LICENSE    = Apache License 2.0
HELPURL    = https://www.home-assistant.io/docs/

WIZARDS_DIR = src/wizard/

SERVICE_SETUP = src/service-setup.sh
SSS_SCRIPT = src/start-stop-status

#DSM UI integration
SERVICE_PORT = 8123

INSTALL_DEP_SERVICES = Docker
START_DEP_SERVICES = Docker

POST_STRIP_TARGET = hassio_extra_install

BUSYBOX_CONFIG = daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: hassio_extra_install
hassio_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/hassio.sh $(STAGING_DIR)/bin/
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/hassio.json $(STAGING_DIR)/var/hassio.dist
