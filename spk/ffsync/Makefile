SPK_NAME = ffsync
SPK_VERS = 1.5.2
SPK_REV = 3
SPK_ICON = src/ffsync.png
BETA = 1

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel
BUILD_DEPENDS += cross/gevent cross/greenlet

DEPENDS     = cross/busybox
WHEELS      = src/requirements.txt

MAINTAINER   = SynoCommunity
DESCRIPTION  = Firefox Sync Server 1.5, used for Firefox 29 and later. You can use Firefox Sync Server to synchronize your bookmarks, passwords, settings, history, add-ons and tabs with Firefox on other computers. The service runs on port 8132.
DISPLAY_NAME = Firefox Sync Server 1.5
CHANGELOG = "1. Fix Python requirement<br>2. Fix startup issue when pidfile is not yet written"

HOMEPAGE     = https://docs.services.mozilla.com/howtos/run-sync-1.5.html
LICENSE      = MPL/GPL/LGPL
HELPURL      = https://github.com/SynoCommunity/spksrc/wiki/Firefox-Sync-Server-1.5

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc
CONF_DIR         = src/conf/

INSTALL_DEP_SERVICES = mysql
START_DEP_SERVICES = mysql

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = ffsync_extra_install

BUSYBOX_CONFIG  = usermng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: ffsync_extra_install
ffsync_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/ffsync.ini $(STAGING_DIR)/var/
	sed -i -e "s|https://github.com/mozilla-services/mozservices/archive/e00e1b68130423ad98d0f6185655bde650443da8.zip|mozsvc==0.8|g" \
	       -e "s|https://github.com/mozilla-services/tokenserver/archive/d7e513e8a4f5c588b70d685a8df1d2e508c341c0.zip|tokenserver==1.2.7|g" \
	       -e "s|http://github.com/mozilla-services/server-syncstorage/archive/1.5.5.zip|SyncStorage==1.5.5|g" \
	       -e "s|https://github.com/mozilla-services/syncserver/archive/1.5.2.tar.gz|syncserver==1.5.2|g" \
                $(STAGING_DIR)/share/wheelhouse/requirements.txt
