SPK_NAME = salt-master
SPK_VERS = 3003.3
SPK_REV  = 1
SPK_ICON = src/salt-master.png

SPK_DEPENDS = "python38"

DEPENDS = cross/patch

BUILD_DEPENDS  = cross/python38 cross/setuptools cross/pip
BUILD_DEPENDS += cross/wheel
BUILD_DEPENDS += cross/salt

include ../../mk/spksrc.archs.mk

# Requirements file generation
# /usr/local/python3/bin/python3 -mvirtualenv --python=python3  salt-env
# virtualenv --python=python3  salt-env
# source salt-env/bin/activate
# pip install salt
# pip freeze > requirements.txt
WHEELS = src/requirements.txt

MAINTAINER   = SynoCommunity
DESCRIPTION  = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
RELOAD_UI    = yes
DISPLAY_NAME = Salt Master
CHANGELOG    = "Update to 3003.3"

HOMEPAGE     = https://www.saltstack.com/
LICENSE      = Apache
LICENSE_FILE = src/LICENSE

POST_STRIP_TARGET = salt-master_extra_install

# Service configuration
CONF_DIR = src/conf
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes

SPK_USR_LOCAL_LINKS = bin:env/bin/salt
SPK_USR_LOCAL_LINKS = bin:env/bin/salt-cp
SPK_USR_LOCAL_LINKS = bin:env/bin/salt-key
SPK_USR_LOCAL_LINKS = bin:env/bin/salt-master
SPK_USR_LOCAL_LINKS = bin:env/bin/salt-run
SPK_USR_LOCAL_LINKS = bin:env/bin/salt-unity
SPK_USR_LOCAL_LINKS = bin:env/bin/spm

include ../../mk/spksrc.spk.mk

.PHONY: salt-master_extra_install
salt-master_extra_install:
	install -m 644 src/rsax931.py.patch $(STAGING_DIR)/share
	install -m 644 src/master $(STAGING_DIR)/share
