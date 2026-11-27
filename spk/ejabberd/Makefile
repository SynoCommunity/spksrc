SPK_NAME = ejabberd
SPK_VERS = 26.09
SPK_REV = 5
SPK_ICON = src/ejabberd.png
DSM_UI_DIR = app

DEPENDS = cross/ejabberd

MAINTAINER = SynoCommunity
DESCRIPTION = Robust, Scalable and Extensible Realtime Platform XMPP Server + MQTT Broker + SIP Service.
ADMIN_URL = /admin/
ADMIN_PORT = 5280
DISPLAY_NAME = ejabberd
CHANGELOG = "1. Update ejabberd to v26.09."

HOMEPAGE = https://www.ejabberd.im
LICENSE  = GPLv2
HELPURL  = https://docs.ejabberd.im/admin/guide

WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
# Custom start/stop is required for the ejabberdctl start/started and
# stop/stopped handshakes; generic stop only terminates the stored PID.
SSS_SCRIPT = src/service-start-stop.sh

FWPORTS = src/ejabberd.sc

SPK_COMMANDS = share/ejabberdctl

POST_STRIP_TARGET = ejabberd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ejabberd_extra_install
ejabberd_extra_install:
	install -m 755 -d $(STAGING_DIR)/app $(STAGING_DIR)/var
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/ejabberd.yml     $(STAGING_DIR)/var/
	install -m 644 src/ejabberdctl.cfg  $(STAGING_DIR)/var/
	install -m 644 src/inetrc           $(STAGING_DIR)/var/
	install -m 755 -d $(STAGING_DIR)/share
	install -m 755 src/bin/ejabberdctl  $(STAGING_DIR)/share/
