SPK_NAME = python310
SPK_VERS = 3.10.16
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 22
SPK_ICON = src/python3.png

DEPENDS  = cross/python310
DEPENDS += cross/pip

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Language de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.10
CHANGELOG = "1. Update to Python 3.10.16<br/>2. Update all mandatory wheels"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

# Force building pure-python wheels
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1
WHEELS = src/requirements-pure.txt

# Force testing all wheel builds
WHEELS_TEST_ALL = 0

# Force compiler LTO optimizations
ifeq ($(strip $(WHEELS_TEST_ALL)),0)
ENV += PYTHON_OPTIMIZE=1
endif

SERVICE_SETUP = src/service-setup.sh

PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python310_extra_install

SPK_USR_LOCAL_LINKS = bin:bin/python3.10

##
## All configurations below are optional and
## are provided to demonstrate how to build
## various wheels.  Uncoment to enable.
##
## WHEELS_TEST_ALL: Force testing all wheel building
ifeq ($(strip $(WHEELS_TEST_ALL)),1)
WHEELS += src/requirements-crossenv.txt
WHEELS += src/requirements-abi3.txt

# [cryptography]
# Use cross/cryptography to generate py36-abi3 limited API
# NOTE: It's not possible to build py36-abi3 limited API using pip due to PEP517
#       To generate py310-py310 regular build use src/requirements-crossenv.txt
DEPENDS += cross/cryptography

# [gevent]
DEPENDS += cross/libev cross/c-ares
ENV += GEVENTSETUP_EMBED_CARES=FALSE
ENV += GEVENTSETUP_EMBED_LIBEV=FALSE

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [mysqlclient]
DEPENDS += cross/mysql-connector-c
DEPENDS += cross/mariadb-connector-c
ENV += MYSQLCLIENT_CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/mysql -I$(STAGING_INSTALL_PREFIX)/include/mariadb -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)"
ENV += MYSQLCLIENT_LDFLAGS="$(LDFLAGS)"

# [Pillow]
DEPENDS += cross/freetype cross/libjpeg cross/zlib
WHEELS_BUILD_ARGS += [Pillow]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --disable-platform-guessing
WHEELS_BUILD_ARGS += --enable-freetype
WHEELS_BUILD_ARGS += --enable-jpeg
WHEELS_BUILD_ARGS += --enable-zlib

# [pycares]
DEPENDS += cross/c-ares
ENV += PYCARES_USE_SYSTEM_LIB=1

# [pycurl]
DEPENDS += cross/curl
ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [PyYAML]
DEPENDS += cross/libyaml

# WHEELS_TEST_ALL: Force testing all wheel building
endif

include ../../mk/spksrc.common.mk

# # Enable debug_info builds for DSM6
# ifeq ($(call version_lt, ${TCVERSION}, 7),1)
# GCC_DEBUG_INFO := 1
# endif

include ../../mk/spksrc.spk.mk

## WHEELS_TEST_ALL: Force testing all wheel building
ifeq ($(strip $(WHEELS_TEST_ALL)),1)

# let it find maturin in crossenv
ENV += PATH=$(WORK_DIR)/crossenv/build/bin:$(PATH)


# [greenlet]
ifeq ($(call version_ge, $(TC_GCC), 4.9),1)
WHEELS += src/requirements-crossenv-greenlet-v2.txt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CPPFLAGS += [greenlet] -std=c++11 -fpermissive
endif
else
WHEELS += src/requirements-crossenv-greenlet-v1.txt
endif

# [numpy] <= 1.21.6 (armv5)
# This version is now unsupported using pip>=23.2.1
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
# [numpy] <= 1.22.4 (armv7l)
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
WHEELS += src/requirements-crossenv-numpy-armv7l.txt
else ifeq ($(call version_le, $(TC_GCC), 5.0),1)
WHEELS += src/requirements-crossenv-numpy-gcc4.txt
# [numpy] >= 1.25.0 requires c++17
else ifeq ($(call version_gt, $(TC_GCC), 5.0),1)
WHEELS += src/requirements-crossenv-numpy.txt
endif
endif

# workaround for compiler bug:
# https://github.com/numpy/numpy/issues/13622
ifeq ($(call version_le, $(TC_GCC), 5.0),1)
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
WHEELS_CFLAGS += [numpy] -O0
endif
endif

# [pycryptodome]
ifeq ($(call version_ge, $(TC_GCC), 4.9),1)
WHEELS_CFLAGS += [pycryptodome] -std=c11
else
WHEELS_CFLAGS += [pycryptodome] -std=c99
endif

# [pycryptodomex]
ifeq ($(call version_ge, $(TC_GCC), 4.9),1)
WHEELS_CFLAGS += [pycryptodomex] -std=c11
else
WHEELS_CFLAGS += [pycryptodomex] -std=c99
endif

# WHEELS_TEST_ALL: Force testing all wheel building
endif

.PHONY: python310_extra_install
python310_extra_install:
	@$(MSG) - Remove compiled files from __pycache__
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' -delete
