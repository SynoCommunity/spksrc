SPK_NAME = salt-minion
SPK_VERS = 3001.1
SPK_REV = 1
SPK_ICON = src/salt-minion.png

PIP = $(WORK_DIR)/../../../native/python3/work-native/install/usr/local/bin/pip
BUILD_DEPENDS = cross/python3
DEPENDS = cross/busybox
SPK_DEPENDS = "python3>=3.7"

# Requirements file generation
# /usr/local/python3/bin/python3 -mvirtualenv --python=python3  salt-env
# virtualenv --python=python3  salt-env
# source salt-env/bin/activate
# pip install salt
# pip freeze > requirements.txt
WHEELS = src/requirements.txt

MAINTAINER = SynoCommunity
DESCRIPTION = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
RELOAD_UI = yes
DISPLAY_NAME = Salt Minion
CHANGELOG = "Update to 3001.1"

HOMEPAGE   = https://www.saltstack.com/
LICENSE    = Apache

POST_STRIP_TARGET = salt-minion_extra_install

# Service configuration
CONF_DIR = src/conf
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

# Busybox config
BUSYBOX_CONFIG = salt-minion
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

# Pure Python package, make sure ARCH is not defined
#override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: salt-minion_extra_install
salt-minion_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/etc/salt
	install -m 755 -d $(STAGING_DIR)/etc/salt/minion.d
	install -m 644 src/rsax931.py.patch $(STAGING_DIR)/share
	install -m 644 src/minion.conf $(STAGING_DIR)/etc/salt
	echo "root_dir: /usr/local/salt-minion" > $(STAGING_DIR)/etc/salt/minion.d/00-root-dir.conf
	echo "master: salt" > $(STAGING_DIR)/etc/salt/minion.d/99-master-address.conf
	echo "id: myname" > $(STAGING_DIR)/etc/salt/minion.d/98-minion-id.conf


