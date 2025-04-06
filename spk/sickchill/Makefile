SPK_NAME = sickchill
SPK_VERS = 20240301
SPK_REV = 11
SPK_ICON = src/sickchill.png

PYTHON_PACKAGE = python311
SPK_DEPENDS = "python311>=3.11.5-8"

# archs without C++11 support are not supported [greenlet]
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = miigotu
DESCRIPTION = Automatic Video Library Manager for TV Shows. It watches for new episodes of your favorite shows, and when they are posted it does its magic.
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "1. Update to SickChill 2024.3.1"

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

POST_STRIP_TARGET = sickchill_extra_install

# [cryptography]
DEPENDS += cross/openssl3

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

include ../../mk/spksrc.python.mk

# [greenlet]
ifeq ($(call version_ge, $(TC_GCC), 5.0),1)
WHEELS += src/requirements-crossenv-greenlet-v3.txt
else ifeq ($(call version_ge, $(TC_GCC), 4.9)$(call version_lt, $(TC_GCC), 5.0),11)
WHEELS += src/requirements-crossenv-greenlet-v3-gcc4.txt
WHEELS_CPPFLAGS += [greenlet] -std=c++11 -fpermissive
else ifeq ($(call version_lt, $(TC_GCC), 4.9),1)
# archs without C++11 support are not supported:
UNSUPPORTED_ARCHS += $(ARCH)
endif

# prefer native python tools (pip, maturin, ...)
ENV += PATH=$(abspath $(WORK_DIR)/../../../native/python311/work-native/install/usr/local/bin):$(PATH)

.PHONY: sickchill_extra_install
sickchill_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
