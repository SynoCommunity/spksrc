SPK_NAME = salt-minion
SPK_VERS = 3006.1
SPK_REV = 5
SPK_ICON = src/salt-minion.png

PYTHON_PACKAGE = python311
SPK_DEPENDS = "python311>=3.11.4-7"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

MAINTAINER   = SynoCommunity
DESCRIPTION  = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
DISPLAY_NAME = Salt Minion
CHANGELOG    = "1. Update to 3006.1<br/>2. Migrate to Python 3.11<br/>3. Migrate to OpenSSL 3.1.2"

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

.PHONY: salt-minion_extra_install
salt-minion_extra_install:
	install -m 644 src/rsax931.py.patch $(STAGING_DIR)/share
	install -m 644 src/minion $(STAGING_DIR)/share
	install -m 644 src/proxy $(STAGING_DIR)/share
