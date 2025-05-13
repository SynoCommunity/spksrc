SPK_NAME = python313-wheels
SPK_VERS = 1.0
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 1
SPK_ICON = src/python3-pip.png

# Compiler must support std=c++11
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

PYTHON_PACKAGE = python313
SPK_DEPENDS = "$(PYTHON_PACKAGE)"

MAINTAINER = SynoCommunity
DESCRIPTION =  Collection of programs for the Python 3.13 programming language.
DESCRIPTION_FRE = Collection of programs for the Python 3.13 programming language.
DESCRIPTION_SPN = Colección de programas para el lenguaje de programación Python 3.13.
STARTABLE = no
DISPLAY_NAME = Python 3.13 Wheels Collection
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

OPTIONAL_DEPENDS  = python/numpy_1.26
OPTIONAL_DEPENDS += python/numpy_ha
OPTIONAL_DEPENDS += python/numpy
OPTIONAL_DEPENDS += python/scipy

include ../../mk/spksrc.common.mk

# [cryptography]
# Use python/cryptography to generate py36-abi3 limited API
# NOTE: It's not possible to build py36-abi3 limited API using pip due to PEP517
#       To generate py311-py311 regular build use src/requirements-crossenv.txt
DEPENDS += python/cryptography

# [mysqlclient]
DEPENDS += cross/mysql-connector-c
DEPENDS += cross/mariadb-connector-c
ENV += MYSQLCLIENT_CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/mysql -I$(STAGING_INSTALL_PREFIX)/include/mariadb -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)"
ENV += MYSQLCLIENT_LDFLAGS="$(LDFLAGS)"

# [Pendulum]
# Needs atomic to build
# Serves as maturin type python-wheel.mk example
ifneq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
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

# [rpds-py]
# Version >= 0.22.3 requires rustc >= 1.80
ifneq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
WHEELS += src/requirements-crossenv-rpds-py.txt
endif

include ../../mk/spksrc.python.mk

# [borgbackup]
# Use OpenSSL path as defined by either
# spksrc.wheel-env.mk or spksrc.python.mk
ENV += BORG_OPENSSL_PREFIX="$(OPENSSL_STAGING_PREFIX)"
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
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [gevent] -std=c11
endif

# [greenlet]
ifeq ($(call version_gt, $(TC_GCC), 5.0),1)
WHEELS += src/requirements-crossenv-greenlet-v3.txt
endif

# [llfuse]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [llfuse] -std=gnu11
endif

# [lxml]
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [lxml] -std=c11
endif

# [msgpack]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [msgpack] -std=c11
endif

# [numpy]
# gcc-8.4 is the minimal version to build numpy
# gcc-8.5 happens to be the default version for DSM-7.1
ifeq ($(call version_gt, $(TC_GCC), 8.4),1)
DEPENDS += python/numpy_1.26
DEPENDS += python/numpy_ha
DEPENDS += python/numpy

# [scipy] - depends on numpy
DEPENDS += python/scipy
endif

# [pycryptodome]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [pycryptodome] -std=c11
endif

# [pycryptodomex]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [pycryptodomex] -std=c11
endif

# [ruamel.yaml.clib]
ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
WHEELS_CFLAGS += [ruamel.yaml.clib] -std=c11
endif
