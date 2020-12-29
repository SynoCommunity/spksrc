SPK_NAME = hassio
SPK_VERS = 20200910
SPK_REV = 2
SPK_ICON = src/$(SPK_NAME).png
SPK_DEPENDS = "Docker>=18.09.0-0506"
DSM_UI_DIR = app

REQUIRED_DSM = 6.2

DEPENDS =

MAINTAINER = fredrike+hassio@gmail.com
DESCRIPTION = "Open source home automation that puts local control and privacy first. Powered by a worldwide community of tinkerers and DIY enthusiasts. Note: identified USB devices will be added to the file usb_devices.txt located in the hass.io folder."
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Hass.io
CHANGELOG = ""

UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

HOMEPAGE   = https://www.home-assistant.io/hassio/
LICENSE    = Apache License 2.0
HELPURL    = https://www.home-assistant.io/docs/

WIZARDS_DIR = src/wizard/

SERVICE_SETUP = src/service-setup.sh

#DSM UI integration
SERVICE_PORT = 8123
SPK_CONFLICT = homeassistant

INSTALL_DEP_SERVICES = Docker
START_DEP_SERVICES = Docker

COPY_TARGET = nop

POST_STRIP_TARGET = hassio_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: hassio_extra_install
hassio_extra_install:
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/hassio.sh $(STAGING_DIR)/bin/
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/hassio.json $(STAGING_DIR)/var/hassio.dist
