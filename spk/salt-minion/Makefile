SPK_NAME = salt-minion
SPK_VERS = 3001.1
SPK_REV = 1
SPK_ICON = src/salt-minion.png

PIP = $(WORK_DIR)/../../../native/python3/work-native/install/usr/local/bin/pip
BUILD_DEPENDS = cross/python3
SPK_DEPENDS = "python3>=3.7"
UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

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

include ../../mk/spksrc.spk.mk

.PHONY: salt-minion_extra_install
salt-minion_extra_install:
	install -m 644 src/rsax931.py.patch $(STAGING_DIR)/share
	install -m 644 src/minion.conf $(STAGING_DIR)/share
