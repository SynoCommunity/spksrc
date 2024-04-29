SPK_NAME = salt-master
SPK_VERS = 3006.1
SPK_REV = 12
SPK_ICON = src/salt-master.png

PYTHON_PACKAGE = python311
SPK_DEPENDS = "$(PYTHON_PACKAGE)>=3.11.4-7"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# TODO: Enable as website to provide salt-master status
DEPENDS = cross/saltgui

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER   = SynoCommunity
DESCRIPTION  = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
DISPLAY_NAME = Salt Master
CHANGELOG    = "1. Update to 3006.1<br/>2. Migrate to Python 3.11<br/>3. Migrate to OpenSSL 3.1.2"

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

# [PyYAML]
DEPENDS += cross/libyaml

# [cryptography]
DEPENDS += cross/cryptography

include ../../mk/spksrc.python.mk

# [pycryptodomex]
ifeq ($(call version_ge, $(TC_GCC), 4.9),1)
WHEELS_CFLAGS += [pycryptodomex] -std=c11
else
WHEELS_CFLAGS += [pycryptodomex] -std=c99
endif

# [pydantic_core]
WHEELS_CFLAGS += [pydantic_core] -std=c11
# Requires path to maturin from crossenv
ENV += PATH=$(WORK_DIR)/crossenv/build/bin:$(PATH)

.PHONY: salt-master_extra_install
salt-master_extra_install:
	install -m 644 src/rsax931.py.patch $(STAGING_DIR)/share
	install -m 644 src/master $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/extensions
	install -m 755 -d $(STAGING_DIR)/share/extensions/auth
	install -m 644 src/synology.py $(STAGING_DIR)/share/extensions/auth/synology.py
