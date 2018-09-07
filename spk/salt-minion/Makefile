SPK_NAME = salt-minion
SPK_VERS = 2018.3.2
SPK_REV = 8
SPK_ICON = src/salt-minion.png

DEPENDS = 
WHEELS = src/requirements.txt
SPK_DEPENDS = "python>2.7.8-10"

MAINTAINER = SynoCommunity
DESCRIPTION = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
RELOAD_UI = yes
DISPLAY_NAME = Salt Minion
CHANGELOG = "Update to 2018.3.2"

HOMEPAGE   = https://www.saltstack.com/
LICENSE    = Apache

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = salt-minion_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: salt-minion_extra_install
salt-minion_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/etc/salt
	install -m 755 -d $(STAGING_DIR)/etc/salt/minion.d
	install -m 644 src/rsax931.py $(STAGING_DIR)/share
	install -m 644 src/minion $(STAGING_DIR)/etc/salt
	echo "root_dir: /usr/local/salt-minion" > $(STAGING_DIR)/etc/salt/minion.d/00-root-dir.conf
	echo "master: salt" > $(STAGING_DIR)/etc/salt/minion.d/99-master-address.conf
	echo "id: myname" > $(STAGING_DIR)/etc/salt/minion.d/98-minion-id.conf


