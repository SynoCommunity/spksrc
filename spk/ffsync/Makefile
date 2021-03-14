SPK_NAME = ffsync
SPK_VERS = 1.8.0
SPK_REV = 4
SPK_ICON = src/ffsync.png
BETA = 1

BUILD_DEPENDS  = cross/python2 cross/setuptools cross/pip_py2 cross/wheel
BUILD_DEPENDS += cross/gevent cross/greenlet
BUILD_DEPENDS += cross/cryptography


MAINTAINER     = SynoCommunity
DESCRIPTION    = Firefox Sync Server allows to synchronize your bookmarks, passwords, settings, history, add-ons and tabs with Firefox on other computers. The service runs on port 8132.
DISPLAY_NAME   = Firefox Sync Server
CHANGELOG      = "Update to version 1.8"

HOMEPAGE       = https://mozilla-services.readthedocs.io/en/latest/howtos/run-sync-1.5.html
LICENSE        = MPL/GPL/LGPL
HELPURL        = https://github.com/SynoCommunity/spksrc/wiki/Firefox-Sync-Server-1.5

WIZARDS_DIR    = src/wizard/
CONF_DIR       = src/conf/

WHEELS         = src/requirements.txt

INSTALL_DEP_SERVICES = mysql
START_DEP_SERVICES = mysql

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh

SERVICE_USER = auto
SERVICE_PORT = 8192
SERVICE_PORT_TITLE = ffsync(TCP)

POST_STRIP_TARGET = ffsync_post_strip

include ../../mk/spksrc.spk.mk

.PHONY: ffsync_post_strip
ffsync_post_strip:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/ffsync.ini $(STAGING_DIR)/var/
	install -m 644 src/requirements.txt $(STAGING_DIR)/share/wheelhouse/requirements.txt
	sed -i -e "s|https://github.com/mozilla-services/tokenserver/archive/1.3.0.zip|tokenserver==1.3.0|g" \
	       -e "s|https://github.com/mozilla-services/server-syncstorage/archive/1.6.13.zip|SyncStorage==1.6.13|g" \
	       -e "s|https://github.com/mozilla-services/syncserver/archive/1.8.0.tar.gz|syncserver==1.8.0|g" \
               $(STAGING_DIR)/share/wheelhouse/requirements.txt
