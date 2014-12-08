SPK_NAME = aria2
SPK_VERS = 1.17.1
SPK_REV = 2
SPK_ICON = src/aria2.png
DSM_UI_DIR = app
BETA = 1

DEPENDS = cross/busybox cross/$(SPK_NAME)

MAINTAINER = cytec
DESCRIPTION = aria2 is a lightweight multi-protocol & multi-source command-line download utility. It supports HTTP/HTTPS, FTP, BitTorrent and Metalink. aria2 can be manipulated via built-in JSON-RPC and XML-RPC interfaces.
ADMIN_URL = /aria2/
RELOAD_UI = yes
DISPLAY_NAME = aria2

HOMEPAGE   = http://aria2.sourceforge.net/
LICENSE    = GPL

WIZARDS_DIR = src/wizard

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web

POST_STRIP_TARGET = aria2_extra_install

BUSYBOX_CONFIG = daemon usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: aria2_extra_install
aria2_extra_install: $(STAGING_DIR)/share/aria2
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/aria2.conf $(STAGING_DIR)/var/aria2.conf
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/aria2:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/ziahamza/webui-aria2 aria2
	cd $(STAGING_DIR)/share/aria2 && rm -rf .git && rm .gitignore