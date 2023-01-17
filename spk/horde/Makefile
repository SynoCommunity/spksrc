SPK_NAME = horde
SPK_VERS = 5.1.0
SPK_REV = 2
SPK_ICON = src/horde.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox

MAINTAINER = moneytoo
DESCRIPTION = Horde Groupware Webmail Edition is a free, enterprise ready, browser based communication suite. Users can read, send and organize email messages and manage and share calendars, contacts, tasks and notes with the standards compliant components from the Horde Project.
ADMIN_URL = /horde/
RELOAD_UI = yes
DISPLAY_NAME = Horde
CHANGELOG = "1. DSM 5.0 compatibility<br>2. Synology Pear dependency"
BETA = 1

HOMEPAGE   = http://www.horde.org/
LICENSE    = LGPL

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = horde_extra_install

BUSYBOX_CONFIG = daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: horde_extra_install
horde_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 src/horde.sh $(STAGING_DIR)/bin/
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
