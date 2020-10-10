SPK_NAME = mosquitto
SPK_VERS = 1.6.12
SPK_REV = 10
SPK_ICON = src/mosquitto.png
DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Mosquitto is an open source message broker that implements the MQTT protocol versions 5.0, 3.1.1 and 3.1.
RELOAD_UI = yes
DISPLAY_NAME = Mosquitto
STARTABLE = yes
CHANGELOG = "Update to 1.6.12"
HOMEPAGE = http://www.mosquitto.org/
LICENSE  = EPL/EDL licensed

SERVICE_USER = auto
# SERVICE_COMMAND is provided there
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT = 1883
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = mosquitto_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: mosquitto_extra_install
mosquitto_extra_install:
	install -d $(STAGING_DIR)/var
	install -m 644 src/mosquitto.conf $(STAGING_DIR)/var/mosquitto.conf
