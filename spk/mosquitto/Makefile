SPK_NAME = mosquitto
SPK_VERS = 1.6.12
SPK_REV = 11
SPK_ICON = src/mosquitto.png
DEPENDS = cross/busybox cross/$(SPK_NAME)

# libwebsockets is not supported for ppc except qoriq
UNSUPPORTED_ARCHS = $(OLD_PCC_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = Mosquitto is an open source message broker that implements the MQTT protocol versions 5.0, 3.1.1 and 3.1.
RELOAD_UI = yes
DISPLAY_NAME = Mosquitto
STARTABLE = yes
CHANGELOG = "Update openssl to 1.1."
HOMEPAGE = https://www.mosquitto.org/
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
