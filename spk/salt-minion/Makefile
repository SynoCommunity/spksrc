SPK_NAME = salt-minion
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
SPK_VERS = 3003.2
else
SPK_VERS = 3000.9
endif
SPK_REV = 1
SPK_ICON = src/salt-minion.png

DEPENDS = cross/patch

# DSM 6 has python2, DSM 7 has python3
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
BUILD_DEPENDS  = cross/python38 cross/setuptools cross/pip
else
BUILD_DEPENDS  = cross/python2 cross/setuptools_py2 cross/pip_py2
SPK_DEPENDS = "python>=2.7.11"
endif
BUILD_DEPENDS += cross/wheel
BUILD_DEPENDS += cross/salt

include ../../mk/spksrc.archs.mk

# Requirements file generation
# /usr/local/python3/bin/python3 -mvirtualenv --python=python3  salt-env
# virtualenv --python=python3  salt-env
# source salt-env/bin/activate
# pip install salt
# pip freeze > requirements.txt
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
WHEELS = src/requirements_gcc46.txt
else
WHEELS = src/requirements.txt
endif
else
WHEELS = src/requirements_py2.txt
endif

MAINTAINER = SynoCommunity
DESCRIPTION = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
RELOAD_UI = yes
DISPLAY_NAME = Salt Minion
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
CHANGELOG = "Update to 3003.2"
else
CHANGELOG = "Last version for Python2 on DSM 6.x is 3000.9"
endif

HOMEPAGE   = https://www.saltstack.com/
LICENSE    = Apache

POST_STRIP_TARGET = salt-minion_extra_install

# Service configuration
CONF_DIR = src/conf
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
SERVICE_SETUP = src/service-setup.sh
else
SERVICE_SETUP = src/service-setup.sh_py2
endif
STARTABLE = yes

include ../../mk/spksrc.spk.mk

.PHONY: salt-minion_extra_install
salt-minion_extra_install:
ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
	install -m 644 src/rsax931.py.patch $(STAGING_DIR)/share
else
	install -m 644 src/rsax931.py.patch_py2 $(STAGING_DIR)/share/rsax931.py.patch
endif
	install -m 644 src/minion.conf $(STAGING_DIR)/share
