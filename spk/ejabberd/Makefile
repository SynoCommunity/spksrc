SPK_NAME = ejabberd
SPK_VERS = 21.07
SPK_REV = 2
SPK_ICON = src/ejabberd.png
DSM_UI_DIR = app

DEPENDS = cross/ejabberd

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = Robust, Scalable and Extensible Realtime Platform XMPP Server + MQTT Broker + SIP Service.
ADMIN_URL = /admin/
ADMIN_PORT = 5280
DISPLAY_NAME = ejabberd

HOMEPAGE = https://www.ejabberd.im
LICENSE  = GPLv2
HELPURL  = https://docs.ejabberd.im/admin/guide

WIZARDS_DIR = src/wizard

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
# custom start-stop-status script is required, 
# as SERVICE_COMMAND is not a single command
SSS_SCRIPT = src/service-start-stop.sh

FWPORTS = src/${SPK_NAME}.sc

SPK_COMMANDS = bin/ejabberdctl

POST_STRIP_TARGET = ejabberd_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: ejabberd_extra_install
ejabberd_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
