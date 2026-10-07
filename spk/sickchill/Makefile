SPK_NAME = sickchill
SPK_VERS = 20260918
SPK_REV = 14
SPK_ICON = src/sickchill.png

PYTHON_PACKAGE = python312

# legacy archs (88f6281, hi3535) have gcc < 4.9 and cannot build the wheel set
MIN_GCC_VERSION = 4.9

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "1. Update to 2026.9.18."

HOMEPAGE = https://sickchill.github.io/
LICENSE = GPLv3+

SERVICE_USER = auto

SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8081
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

USE_ALTERNATE_TMPDIR = 1

POST_SERVICE_TARGET = sickchill_extra_install

include ../../mk/spksrc.common.mk

# sickchill is not on PyPI (GitHub tags only), build its wheel here
DEPENDS += python/sickchill

# [cryptography]
# 48.0.1 needs rustc >= 1.83; older pinned toolchains (e.g. qoriq/rust 1.82)
# stay on 46.0.7.
DEPENDS += cross/openssl3
ifeq ($(call version_ge, $(TC_RUSTC), 1.83),1)
WHEELS += cryptography==48.0.1
else
WHEELS += cryptography==46.0.7
endif

# [PyYAML]
DEPENDS += cross/libyaml

# [greenlet]
# 3.5.x needs C++20 (gcc >= 8); older toolchains build 3.0.x instead.
# Upstream requires >= 3.5.5, relaxed by python/sickchill patch.
ifeq ($(call version_ge, $(TC_GCC), 8.0),1)
WHEELS += greenlet==3.5.6
else
WHEELS += greenlet==3.0.3
WHEELS_CPPFLAGS += [greenlet] -std=c++11 -fpermissive
endif

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
# Cython 3.1 atomics detection chokes GCC 4.x preprocessors; lxml runs
# fine without them (non-atomic fallback).
WHEELS_CFLAGS += [lxml] -std=c11 -DCYTHON_ATOMICS=0
endif

# [msgpack]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [msgpack] -std=c11
WHEELS += msgpack==1.0.5
else
WHEELS += msgpack==1.2.3
endif

include ../../mk/spksrc.spk-meta.mk

.PHONY: sickchill_extra_install
sickchill_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	@$(MSG) Substituting PYTHON_PACKAGE in service-setup
	@sed -i 's|@@PYTHON_PACKAGE@@|$(PYTHON_PACKAGE)|g' $(WORK_DIR)/scripts/service-setup
