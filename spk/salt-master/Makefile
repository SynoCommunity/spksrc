SPK_NAME = salt-master
SPK_VERS = 3003.3
SPK_REV  = 10
SPK_ICON = src/salt-master.png

SPK_DEPENDS = "python38"

DEPENDS =

BUILD_DEPENDS  = cross/python38 cross/setuptools cross/pip
BUILD_DEPENDS += cross/wheel
BUILD_DEPENDS += cross/salt

# Requirements file generation
# /usr/local/python3/bin/python3 -mvirtualenv --python=python3  salt-env
# virtualenv --python=python3  salt-env
# source salt-env/bin/activate
# pip install salt
# pip freeze > requirements.txt
WHEELS = src/requirements.txt

MAINTAINER   = SynoCommunity
DESCRIPTION  = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
DISPLAY_NAME = Salt Master
CHANGELOG    = "Update to 3003.3"

HOMEPAGE     = https://www.saltstack.com/
LICENSE      = Apache
LICENSE_FILE = $(WORK_DIR)/salt-$(SPK_VERS)/LICENSE

POST_STRIP_TARGET = salt-master_extra_install

# Service configuration
SERVICE_USER       = auto
SERVICE_SETUP      = src/service-setup.sh
SERVICE_PORT       = 4505,tcp/4506,tcp/8282
SERVICE_PORT_TITLE = $(DISPLAY_NAME)
FWPORTS = src/${SPK_NAME}.sc
STARTABLE = yes

SPK_USR_LOCAL_LINKS  = bin:env/bin/salt
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-cp
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-key
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-master
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-run
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-unity
SPK_USR_LOCAL_LINKS += bin:env/bin/spm

include ../../mk/spksrc.spk.mk

.PHONY: salt-master_extra_install
salt-master_extra_install:
	install -m 644 src/rsax931.py.patch $(STAGING_DIR)/share
	install -m 644 src/master $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/extensions
	install -m 755 -d $(STAGING_DIR)/share/extensions/auth
	install -m 644 src/synology.py $(STAGING_DIR)/share/extensions/auth/synology.py
