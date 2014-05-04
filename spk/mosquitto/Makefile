SPK_NAME = mosquitto
SPK_VERS = 1.3.1
SPK_REV = 1
SPK_ICON = src/mosquitto.png
SPK_ICON_120 = src/mosquitto_120.png
DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Mosquitto is an open source message broker that implements the MQ Telemetry Transport protocol version 3.1.1. To edit mosquitto.conf use ssh-terminal to go to /var/packages/mosquitto/target/etc/
RELOAD_UI = yes
DISPLAY_NAME = Mosquitto
STARTABLE = yes
CHANGELOG = "1. Package creation"
HOMEPAGE = http://www.mosquitto.org/
LICENSE  = BSD licensed

BETA = 1

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = mosquitto_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: mosquitto_extra_install
mosquitto_extra_install:
	install -d $(STAGING_DIR)/etc
	install -d $(STAGING_DUR)/var
	install -m 644 src/etc/mosquitto.conf $(STAGING_DIR)/etc/mosquitto.conf
	install -m 644 src/etc/aclfile.example $(STAGING_DIR)/etc/aclfile
	install -m 644 src/etc/pwfile.example $(STAGING_DIR)/etc/pwfile
	install -m 644 src/etc/pskfile.example $(STAGING_DIR)/etc/pskfile
	rm -rf $(STAGING_DIR)/lib/
	rm -f $(STAGING_DIR)/bin/openssl
	rm -f $(STAGING_DIR)/openssl.cnf
