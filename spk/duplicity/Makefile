SPK_NAME = duplicity
SPK_VERS = 3.2.1
SPK_REV = 14
SPK_ICON = src/duplicity.png

# The protobuf wheel includes stdatomic.h (upb/port/atomic.h), which gcc ships from 4.9 on.
MIN_GCC_VERSION = 4.9

PYTHON_PACKAGE = python314
SPK_DEPENDS = "gnupg>=2.1.6"
WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

DEPENDS = cross/librsync cross/duply

MAINTAINER = SynoCommunity
DESCRIPTION = Encrypted bandwidth-efficient backup using the rsync algorithm. Also contains duply wrapper script (duply is supported only for DSM >= 6.0).
STARTABLE = no
DISPLAY_NAME = Duplicity
CHANGELOG = "1. Update duplicity to v3.2.1 and duply to v2.5.6. <br/>2. Migrate to Python 3.14."

HOMEPAGE = https://duplicity.gitlab.io/duplicity-web/
LICENSE  = GPLv2

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

# use alternate TMPDIR as /tmp might be too small.
USE_ALTERNATE_TMPDIR = 1

SPK_COMMANDS = bin/duply bin/duplicity

SPK_USR_LOCAL_LINKS  = bin:env/bin/duplicity
SPK_USR_LOCAL_LINKS += bin:bin/duply

include ../../mk/spksrc.common.mk

# [cryptography]
DEPENDS += cross/openssl3

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
# Cython 3.1 atomics detection chokes GCC 4.x preprocessors; lxml runs
# fine without them (non-atomic fallback).
WHEELS_CFLAGS += [lxml] -std=c11 -DCYTHON_ATOMICS=0
endif

# [protobuf]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CPPFLAGS = [protobuf] -std=c11
endif

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [PyYAML]
DEPENDS += cross/libyaml

# [duplicity]
#   - To be built last
DEPENDS += python/duplicity

POST_SERVICE_TARGET = duplicity_extra_install

include ../../mk/spksrc.spk-meta.mk

.PHONY: duplicity_extra_install
duplicity_extra_install:
	@$(MSG) Substituting PYTHON_PACKAGE in service-setup
	@sed -i 's|@@PYTHON_PACKAGE@@|$(PYTHON_PACKAGE)|g' $(WORK_DIR)/scripts/service-setup
