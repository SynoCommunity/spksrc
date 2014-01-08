SPK_NAME = etherpad
SPK_VERS = 1.3
SPK_REV = 1
SPK_ICON = src/etherpad.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox
SPK_DEPENDS = node

MAINTAINER = SynoCommunity
DESCRIPTION = Etherpad allows you to edit documents collaboratively in real-time, much like a live multi-player editor that runs in your browser. Write articles, press releases, to-do lists, etc. together with your friends, fellow students or colleagues, all working on the same document at the same time.
ADMIN_URL = /admin/
ADMIN_PORT = 9001
RELOAD_UI = yes
DISPLAY_NAME = Etherpad
BETA = 1

HOMEPAGE   = http://etherpad.org/
LICENSE    = Apache License v2

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = etherpad_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: etherpad_extra_install
etherpad_extra_install: $(STAGING_DIR)/share/etherpad
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/settings.json $(STAGING_DIR)/share/etherpad/settings.json
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/etherpad:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/ether/etherpad-lite.git etherpad
	
