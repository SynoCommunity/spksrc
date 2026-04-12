SPK_NAME = python314-wheels
SPK_VERS = 1.0
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 1
SPK_ICON = src/python3-pip.png

# Compiler must support std=c++11
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

PYTHON_PACKAGE = python314
SPK_DEPENDS = "$(PYTHON_PACKAGE)"

MAINTAINER = SynoCommunity
DESCRIPTION =  Collection of programs for the Python 3.14 programming language.
DESCRIPTION_FRE = Collection of programs for the Python 3.14 programming language.
DESCRIPTION_SPN = Colección de programas para el lenguaje de programación Python 3.14.
STARTABLE = no
DISPLAY_NAME = Python 3.14 Wheels Collection
CHANGELOG = "1. Initial package"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

# Enable debug_info symbols
#GCC_DEBUG_INFO := 1

# IMPORTANT: WHEELS must be initialized before include of spksrc.python.mk
# later additions are ok, but WHEELS must not be empty at this point,
# otherwise the build of WHEELS is skipped
WHEELS += src/requirements-abi3.txt
WHEELS += src/requirements-crossenv.txt
WHEELS += src/requirements-pure.txt

SERVICE_SETUP = src/service-setup.sh

OPTIONAL_DEPENDS += python/numpy_1.26
OPTIONAL_DEPENDS += python/numpy
OPTIONAL_DEPENDS += python/numpy-latest
OPTIONAL_DEPENDS += python/pandas
OPTIONAL_DEPENDS += python/scipy

include ../../mk/spksrc.common.mk

# [borgbackup]
# Use OpenSSL path as defined by either
# spksrc.wheel-env.mk or spksrc.python.mk
ENV += BORG_OPENSSL_PREFIX="$(OPENSSL_STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBACL_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBB2_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBLZ4_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBXXHASH_PREFIX="$(STAGING_INSTALL_PREFIX)"
ENV += BORG_LIBZSTD_PREFIX="$(STAGING_INSTALL_PREFIX)"
DEPENDS += cross/attr cross/acl cross/openssl3 cross/lz4 cross/libb2 cross/fuse cross/xxhash cross/zstd
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [borgbackup] -std=c11
endif

# [gevent]
DEPENDS += cross/libev cross/c-ares
ENV += GEVENTSETUP_EMBED_CARES=FALSE
ENV += GEVENTSETUP_EMBED_LIBEV=FALSE
ifeq ($(call version_lt, $(TC_GCC), 4.9),1)
WHEELS += gevent==24.11.1
else
WHEELS += gevent==25.9.1
endif
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [gevent] -std=c11
endif

# [greenlet]
# version >= 3.1: gcc >= 8   (DSM7.1) Mandatory require full c++20 support
# version  = 3.0: gcc >= 4.9 (DSM6, comcerto2k) Mandatory require full c++11 support *** unsupported ***
ifeq ($(call version_ge, $(TC_GCC), 8),1)
WHEELS += greenlet==3.3.2
endif

# [llfuse]
# llfuse<=1.5.1 using gcc<5 requires -std=gnu11 to find "clock_gettime"
# llfuse>=1.5.2 requires gcc>=7
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [llfuse] -std=gnu11
WHEELS += llfuse==1.5.1
else
WHEELS += llfuse==1.5.2
endif

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [lxml] -std=c11
WHEELS += lxml==5.4.0
else
WHEELS += lxml==6.0.2
endif

# [msgpack]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [msgpack] -std=c11
endif

# [mysqlclient]
DEPENDS += cross/mariadb-connector-c
ENV += MYSQLCLIENT_CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/mysql -I$(STAGING_INSTALL_PREFIX)/include/mariadb -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)"
ENV += MYSQLCLIENT_LDFLAGS="$(LDFLAGS)"

# [numpy]
# version == 1.26 -> NOT officially supported python>3.13
# version >= 2.3  -> Requires gcc >= 9.4 -> DSM-7.2 (using patch for DSM-7.1 gcc-8.5)
ifeq ($(call version_ge, $(TC_GCC), 8.5),1)
DEPENDS += python/numpy_1.26
DEPENDS += python/numpy
DEPENDS += python/numpy-latest
endif

# [pandas] - depends on numpy >= 2.x
ifeq ($(call version_ge, $(TC_GCC), 8.5),1)
DEPENDS += python/pandas
endif

# [Pendulum]
# Needs atomic to build
# Serves as maturin type python-wheel.mk example
ifneq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += python/pendulum
endif

# [Pillow]
DEPENDS += python/pillow

# [psutil]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [psutil] -std=gnu99
endif

# [pycares]
DEPENDS += cross/c-ares
ENV += PYCARES_USE_SYSTEM_LIB=1

# [pycryptodome]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [pycryptodome] -std=c11
endif

# [pycryptodomex]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [pycryptodomex] -std=c11
endif

# [pycurl]
DEPENDS += cross/curl
ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

# [pydantic-core] 
DEPENDS += python/pydantic-core

# [pygobject]
ifeq ($(call version_ge, $(TC_GCC), 5.0),1)
DEPENDS += python/pygobject
endif

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
# Version = 0.24 requires rustc >= 1.82 (qoriq) ==> No longer supported by py314
# Version = 0.25 requires rustc >= 1.85
ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
WHEELS += rpds_py==0.30.0
endif

# [ruamel.yaml.clib]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [ruamel.yaml.clib] -std=c11
endif

# [scipy] - depends on numpy >= 2.x
ifeq ($(call version_ge, $(TC_GCC), 8.5),1)
DEPENDS += python/scipy
endif

include ../../mk/spksrc.python.mk
