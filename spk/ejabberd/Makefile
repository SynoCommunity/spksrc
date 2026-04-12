SPK_NAME = ejabberd
SPK_VERS = 23.10
SPK_REV = 3
SPK_ICON = src/ejabberd.png
DSM_UI_DIR = app

DEPENDS = cross/ejabberd

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = Robust, Scalable and Extensible Realtime Platform XMPP Server + MQTT Broker + SIP Service.
ADMIN_URL = /admin/
ADMIN_PORT = 5280
DISPLAY_NAME = ejabberd
CHANGELOG = "1. Update ejabberd to v23.10. <br/>2. Fix configuration for DSM 7+. <br/>3. Fix web admin authentication."

HOMEPAGE = https://www.ejabberd.im
LICENSE  = GPLv2
HELPURL  = https://docs.ejabberd.im/admin/guide

WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
# custom start-stop-status script is required, 
# as SERVICE_COMMAND is not a single command
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
