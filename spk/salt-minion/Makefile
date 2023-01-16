SPK_NAME = salt-minion
SPK_VERS = 3004
SPK_REV = 3
SPK_ICON = src/salt-minion.png

BUILD_DEPENDS = cross/python310
SPK_DEPENDS = "python310"

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
DISPLAY_NAME = Salt Minion
CHANGELOG    = "1. Update to 3004<br/>2. Migrate to Python 3.10"

HOMEPAGE     = https://repo.saltproject.io/
LICENSE      = Apache
#LICENSE_FILE = $(WORK_DIR)/salt-$(SPK_VERS)/LICENSE

POST_STRIP_TARGET = salt-minion_extra_install

# Service configuration
SERVICE_USER  = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE     = yes

SPK_USR_LOCAL_LINKS  = bin:env/bin/salt-call
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-minion
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-proxy
SPK_USR_LOCAL_LINKS += bin:env/bin/spm

USE_ALTERNATE_TMPDIR = 1

include ../../mk/spksrc.spk.mk

.PHONY: salt-minion_extra_install
salt-minion_extra_install:
	install -m 644 src/rsax931.py.patch $(STAGING_DIR)/share
	install -m 644 src/minion $(STAGING_DIR)/share
	install -m 644 src/proxy $(STAGING_DIR)/share
