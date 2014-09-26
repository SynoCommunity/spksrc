SPK_NAME = syncserver
SPK_VERS = 1.1
SPK_REV = 1
SPK_ICON = src/syncserver.png
DSM_UI_DIR = app

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel cross/scrypt
DEPENDS  = cross/busybox
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>=2.7.6-8"

MAINTAINER = SynoCommunity
DESCRIPTION = Python implementation of Firefox Sync Server 1.1, used for Firefox 28 and earlier. You can use Firefox Sync Server to synchronize your bookmarks, passwords, settings, history, add-ons and tabs with Firefox on other computers. Set up Firefox Sync on your main computer by creating a new account on a custom server, then add your other computers. The service runs on port 8130.
DISPLAY_NAME = Firefox Sync Server
BETA = 1

HOMEPAGE   = https://wiki.mozilla.org/Services/Sync/Server
LICENSE    = MPL/GPL/LGPL
HELPURL    = http://synocommunity.com/help/syncserver

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = syncserver_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: syncserver_extra_install
syncserver_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/share/wheelhouse
	install -m 644 $(WORK_DIR)/wheelhouse/* $(STAGING_DIR)/share/wheelhouse/
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 755 src/syncserver.conf $(STAGING_DIR)/var/
	install -m 755 src/syncserver.ini $(STAGING_DIR)/var/
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
			$(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	sed -i -e "s|hg+http://hg.mozilla.org/services/server-core@1069|Services == 2.15|g" \
	       -e "s|hg+http://hg.mozilla.org/services/server-reg@552|SyncReg == 1.2|g" \
	       -e "s|hg+http://hg.mozilla.org/services/server-storage@813|SyncStorage == 1.17|g" \
	       -e "s|hg+http://hg.mozilla.org/services/server-full@549|SyncServer == 1.0|g" \
                $(STAGING_DIR)/share/wheelhouse/requirements.txt
