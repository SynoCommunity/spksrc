SPK_NAME = horde
SPK_VERS = 5.0.4
SPK_REV = 1
SPK_ICON = src/horde.png
DSM_UI_DIR = app

DEPENDS  = cross/pear

MAINTAINER = SynoCommunity
DESCRIPTION = Horde Groupware Webmail Edition is a free, enterprise ready, browser based communication suite. Users can read, send and organize email messages and manage and share calendars, contacts, tasks and notes with the standards compliant components from the Horde Project.
ADMIN_URL = /horde/
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Horde
BETA = 1

HOMEPAGE   = http://www.horde.org/
LICENSE    = LGPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = horde_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: horde_extra_install
horde_extra_install:
	# Fix hard coded paths
	sed -i "s|$(STAGING_INSTALL_PREFIX)/share/pear|$(INSTALL_PREFIX)/share/pear|g" $(STAGING_DIR)/bin/*
	sed -i "s|$(STAGING_INSTALL_PREFIX)/share/pear|$(INSTALL_PREFIX)/share/pear|g" $(STAGING_DIR)/share/pear/*cmd.php

	# Fix Synology bug (non working gzseek())
	@sed -i 's/@gzseek($$this->_file, gztell($$this->_file)+($$p_len\*512));/@gzread($$this->_file, $$p_len\*512);/g' $(STAGING_DIR)/share/pear/Archive/Tar.php

	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
