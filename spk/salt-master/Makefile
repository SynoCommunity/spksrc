SPK_NAME = salt-master
SPK_VERS = 3004
SPK_REV = 11
SPK_ICON = src/salt-master.png

BUILD_DEPENDS = cross/python310
SPK_DEPENDS = "python310"
# TODO: Enable as website to provide salt-master status
DEPENDS = cross/saltgui

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS)

# Requirements file generation
# /usr/local/python3/bin/python3 -mvirtualenv --python=python3  salt-env
# virtualenv --python=python3  salt-env
# source salt-env/bin/activate
# pip install salt
# pip freeze > requirements.txt
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER   = SynoCommunity
DESCRIPTION  = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
DISPLAY_NAME = Salt Master
CHANGELOG    = "1. Update to 3004<br/>2. Migrate to Python 3.10"

HOMEPAGE     = https://repo.saltproject.io/
LICENSE      = Apache v2
#LICENSE_FILE = $(WORK_DIR)/salt-$(SPK_VERS)/LICENSE

POST_STRIP_TARGET = salt-master_extra_install

# Service configuration
SERVICE_USER       = auto
SERVICE_SETUP      = src/service-setup.sh
STARTABLE          = yes
FWPORTS            = src/conf/salt-master.sc

SPK_USR_LOCAL_LINKS  = bin:env/bin/salt
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-cp
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-key
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-master
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-run
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-unity
SPK_USR_LOCAL_LINKS += bin:env/bin/spm
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-ssh

USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk

.PHONY: salt-master_extra_install
salt-master_extra_install:
	install -m 644 src/rsax931.py.patch $(STAGING_DIR)/share
	install -m 644 src/master $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/extensions
	install -m 755 -d $(STAGING_DIR)/share/extensions/auth
	install -m 644 src/synology.py $(STAGING_DIR)/share/extensions/auth/synology.py
