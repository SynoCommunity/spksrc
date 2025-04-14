SPK_NAME = salt-master
SPK_VERS = 3007.1
SPK_REV = 12
SPK_ICON = src/salt-master.png

PYTHON_PACKAGE = python312
SPK_DEPENDS = "$(PYTHON_PACKAGE)"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER   = SynoCommunity
DESCRIPTION  = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
DISPLAY_NAME = Salt Master
CHANGELOG    = "1. Update to 3007.1<br/>2. Migrate to Python 3.12"

HOMEPAGE     = https://repo.saltproject.io/
LICENSE      = Apache v2
#LICENSE_FILE = $(WORK_DIR)/salt-$(SPK_VERS)/LICENSE

POST_STRIP_TARGET = salt-master_extra_install

# Service configuration
SERVICE_USER       = auto
SERVICE_SETUP      = src/service-setup.sh
STARTABLE          = yes
FWPORTS            = src/app/salt-master.sc
CONF_DIR           = src/conf/

SPK_USR_LOCAL_LINKS  = bin:env/bin/salt
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-cp
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-key
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-master
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-run
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-unity
SPK_USR_LOCAL_LINKS += bin:env/bin/spm
SPK_USR_LOCAL_LINKS += bin:env/bin/salt-ssh

USE_ALTERNATE_TMPDIR = 1

# [cryptography]
DEPENDS += cross/openssl3

# [PyYAML]
DEPENDS += cross/libyaml

include ../../mk/spksrc.python.mk

# [aiohttp]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [aiohttp] -std=c11
endif

# [frozenlist]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [frozenlist] -std=c11
endif

# [msgpack]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [msgpack] -std=c11
endif

# [pycryptodomex]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [pycryptodomex] -std=c11
endif

# [pydantic_core]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [pydantic_core] -std=c11
endif

# [pyzmq]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [pyzmq] -std=c11
endif

.PHONY: salt-master_extra_install
salt-master_extra_install:
	install -m 644 src/app/rsax931.py.patch $(STAGING_DIR)/share
	install -m 644 src/app/master $(STAGING_DIR)/share
	install -m 755 -d $(STAGING_DIR)/share/extensions
	install -m 755 -d $(STAGING_DIR)/share/extensions/auth
	install -m 644 src/app/synology.py $(STAGING_DIR)/share/extensions/auth/synology.py
