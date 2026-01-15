SPK_NAME = python311-wheels
SPK_VERS = 1.0
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 1
SPK_ICON = src/python3-pip.png

# Platform "powerpc-none-linux-gnuspe" with compiler "gcc" is not supported by the
# CPython core team, see https://peps.python.org/pep-0011/ for more information.
# And compiler must support std=c++11 (OlD_PPC_ARCHS fail, but ARMv5_ARCHS have no issue).
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

PYTHON_PACKAGE = python311
SPK_DEPENDS = "$(PYTHON_PACKAGE)"

MAINTAINER = SynoCommunity
DESCRIPTION =  Collection of programs for the Python 3.11 programming language.
DESCRIPTION_FRE = Collection of programs for the Python 3.11 programming language.
DESCRIPTION_SPN = Colección de programas para el lenguaje de programación Python 3.11.
STARTABLE = no
DISPLAY_NAME = Python 3.11 Wheels Collection
CHANGELOG = "1. Initial package"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

# Enable debug_info symgols
#GCC_DEBUG_INFO := 1

# IMPORTANT: WHEELS must be initialized before include of spksrc.python.mk
# later additions are ok, but WHEELS must not be empty at this point,
# otherwise the build of WHEELS is skipped
WHEELS += src/requirements-abi3.txt
WHEELS += src/requirements-crossenv.txt
WHEELS += src/requirements-pure.txt

SERVICE_SETUP = src/service-setup.sh

OPTIONAL_DEPENDS  = python/numpy_1.26
OPTIONAL_DEPENDS += python/numpy
OPTIONAL_DEPENDS += python/pandas
OPTIONAL_DEPENDS += python/scipy

include ../../mk/spksrc.common.mk

# [borgbackup]
# Use OpenSSL path as defined by either
# spksrc.wheel-env.mk or spksrc.python.mk
ENV += BORG_OPENSSL_PREFIX="$(OPENSSL_STAGING_PREFIX)"
ENV += BORG_LIBLZ4_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBZSTD_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBB2_PREFIX="$(STAGING_INSTALL_PREFIX)"
DEPENDS += cross/attr cross/acl cross/openssl3 cross/lz4 cross/zstd cross/libb2 cross/fuse

# [cryptography]
# Use python/cryptography to generate py36-abi3 limited API
# NOTE: It's not possible to build py36-abi3 limited API using pip due to PEP517
#       To generate py311-py311 regular build use src/requirements-crossenv.txt
DEPENDS += python/cryptography

# [gevent]
DEPENDS += cross/libev cross/c-ares
ENV += GEVENTSETUP_EMBED_CARES=FALSE
ENV += GEVENTSETUP_EMBED_LIBEV=FALSE
ifeq ($(call version_lt, $(TC_GCC), 4.9),1)
WHEELS += gevent==24.11.1
else
WHEELS += gevent==25.5.1
endif

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
ifeq ($(call version_lt, $(TC_GCC), 4.8),1)
WHEELS_CFLAGS += [lxml] -std=gnu99
WHEELS += lxml==5.4.0
else ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [lxml] -std=c11
WHEELS += lxml==5.4.0
else
WHEELS += lxml==6.0.2
endif

# [mysqlclient]
DEPENDS += cross/mariadb-connector-c
ENV += MYSQLCLIENT_CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/mysql -I$(STAGING_INSTALL_PREFIX)/include/mariadb -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)"
ENV += MYSQLCLIENT_LDFLAGS="$(LDFLAGS)"

# [Pendulum]
# Needs atomic to build
# Serves as maturin type python-wheel.mk example
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += python/pendulum
endif

# [Pillow]
DEPENDS += python/pillow

# [pycares]
DEPENDS += cross/c-ares
ENV += PYCARES_USE_SYSTEM_LIB=1

# [pycurl]
DEPENDS += cross/curl
ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

# [pydantic-core]
DEPENDS += python/pydantic-core

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [PyYAML]
DEPENDS += cross/libyaml

# [rencode]
DEPENDS += python/rencode

# [rpds-py]
# Require environment variables
#   PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
#   PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/
# Version = 0.21 requires rustc >= 1.77 (armv5)
# Version = 0.24 requires rustc >= 1.82 (qoriq)
# Version = 0.25 requires rustc >= 1.85
ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
WHEELS += rpds_py==0.21.0
else ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
WHEELS += rpds_py==0.24.0
else
WHEELS += rpds_py==0.25.1
endif

include ../../mk/spksrc.python.mk

# [atom]
# Requires
#  - build:setuptools-scm
#  - cross:cppy
ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
WHEELS += atom==0.10.5
WHEELS += atom==0.11.0
endif

# [greenlet]
# version >= 3.1: gcc >= 8   (DSM7.1) Mandatory require full c++20 support
# version  = 3.0: gcc >= 4.9 (DSM6, comcerto2k) Mandatory require full c++11 support
# version  = 1.x: gcc <  4.9 (DSM5, DSM6) Last known working version (armv5, hi3535)
ifeq ($(call version_ge, $(TC_GCC), 8),1)
WHEELS += greenlet==3.2.3
else ifeq ($(call version_ge, $(TC_GCC), 4.9)$(call version_lt, $(TC_GCC), 5.0),11)
WHEELS += greenlet==3.0.3
WHEELS_CPPFLAGS += [greenlet] -std=c++11 -fpermissive
else
WHEELS += greenlet==1.1.3
endif

# [numpy]
# version <= 1.21 (armv5)  Requires python '<3.11,>=3.7' *** unsupported ***
# version <= 1.22 (armv7l) Last working version
# version <= 1.24 (DSM6, comcerto2k) Last working version with gcc-4.9
# version >= 1.25 (DSM7)   Mandatory requires c++17
# version == 1.25.2        BUG only on x86_64 gcc-8.5.0 DSM-7.1 -> Fallback to 1.25.1
# version >= 1.26 (DSM7)   Mandatory requires gcc >= 8.4
# version >= 2.3  (DSM7.2) Requires gcc >= 9.4
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
WHEELS += numpy==1.22.4
else ifeq ($(call version_le, $(TC_GCC), 5.0),1)
WHEELS += numpy==1.24.4
# workaround for compiler bug:
# https://github.com/numpy/numpy/issues/13622
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
WHEELS_CFLAGS += [numpy] -O0
endif
else ifeq ($(call version_gt, $(TC_GCC), 8.4),1)
DEPENDS += python/numpy_1.26
DEPENDS += python/numpy
endif
endif

# [scipy] - depends on numpy >= 2.x
ifeq ($(call version_ge, $(TC_GCC), 8.4),1)
DEPENDS += python/scipy
endif

# [pandas] - depends on numpy >= 1.26
ifeq ($(call version_ge, $(TC_GCC), 8.4),1)
DEPENDS += python/pandas
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

# [pygobject]
ifeq ($(call version_ge, $(TC_GCC), 5.0),1)
DEPENDS += python/pygobject
endif
