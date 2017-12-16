SPK_NAME = ejabberd
SPK_VERS = 2.1.13
SPK_REV = 1
SPK_ICON = src/ejabberd.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/erlang cross/ejabberd

MAINTAINER = SynoCommunity
DESCRIPTION = ejabberd is high-performace enterprise Jabber/XMPP instant messaging server written in Erlang/OTP. It\'s cross-platform, fault-tolerant, clusterable and modular.
ADMIN_URL = /admin/
ADMIN_PORT = 5280
RELOAD_UI = yes
DISPLAY_NAME = ejabberd
BETA = 1

HOMEPAGE   = http://www.ejabberd.im
LICENSE    = GPLv2
HELPURL    = http://docs.ejabberd.im/admin/guide

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = ejabberd_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: ejabberd_extra_install
ejabberd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
