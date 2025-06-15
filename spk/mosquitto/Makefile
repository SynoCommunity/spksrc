SPK_NAME = mosquitto
SPK_VERS = 2.0.20
SPK_REV = 16
SPK_ICON = src/mosquitto.png

DEPENDS = cross/mosquitto

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = Eclipse Mosquitto is an open source \(EPL/EDL licensed\) message broker that implements the MQTT protocol versions 5.0, 3.1.1 and 3.1.
DISPLAY_NAME = Mosquitto
CHANGELOG = "Update mosquitto to v2.0.20. Update libwebsockets to v4.3.3."
HOMEPAGE = https://www.mosquitto.org/
LICENSE  = EPL/EDL

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
STARTABLE = yes
# SERVICE_COMMAND is provided there
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT = 1883
SERVICE_PORT_TITLE = Mosquitto MQTT (TCP)
NO_SERVICE_SHORTCUT = yes

POST_STRIP_TARGET = mosquitto_extra_install

SPK_COMMANDS  = bin/mosquitto_ctrl
SPK_COMMANDS += bin/mosquitto_passwd
SPK_COMMANDS += bin/mosquitto_rr
SPK_COMMANDS += bin/mosquitto_pub
SPK_COMMANDS += bin/mosquitto_sub

include ../../mk/spksrc.spk.mk

.PHONY: mosquitto_extra_install
mosquitto_extra_install:
	install -d $(STAGING_DIR)/var
	install -m 644 src/mosquitto.conf $(STAGING_DIR)/var/mosquitto.conf
	install -m 644 src/passwd $(STAGING_DIR)/var/passwd
