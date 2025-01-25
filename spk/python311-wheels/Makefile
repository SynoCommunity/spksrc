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

WHEELS  = src/requirements-abi3.txt
WHEELS += src/requirements-crossenv.txt
WHEELS += src/requirements-pure.txt

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
# Use cross/cryptography to generate py36-abi3 limited API
# NOTE: It's not possible to build py36-abi3 limited API using pip due to PEP517
#       To generate py311-py311 regular build use src/requirements-crossenv.txt
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

# [Pendulum]
# Needs atomic to build
# Serves as maturin type python-wheel.mk example
ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/pendulum
endif

# [Pillow]
DEPENDS += cross/pillow

# [pycares]
DEPENDS += cross/c-ares
ENV += PYCARES_USE_SYSTEM_LIB=1

# [pycurl]
DEPENDS += cross/curl
ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

# [pydantic-core]
DEPENDS += cross/pydantic-core

# [PyNaCl]
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [PyYAML]
DEPENDS += cross/libyaml

# [rpds-py]
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
WHEELS += src/requirements-crossenv-rpds-py.txt
endif

##
## Addition of requirements files beyond spksrc.python.mk
## will not be taken into consideration for processing
## unless WHEELS has been previously populated. This is due to
## the makefile analysis phase which discard ifeq instructions.
##

include ../../mk/spksrc.python.mk

# [greenlet]
ifeq ($(call version_ge, $(TC_GCC), 5.0),1)
WHEELS += src/requirements-crossenv-greenlet-v3.txt
else ifeq ($(call version_ge, $(TC_GCC), 4.9)$(call version_lt, $(TC_GCC), 5.0),11)
WHEELS += src/requirements-crossenv-greenlet-v3-gcc4.txt
WHEELS_CPPFLAGS += [greenlet] -std=c++11 -fpermissive
else
WHEELS += src/requirements-crossenv-greenlet-v1.txt
endif

# [numpy] <= 1.21.6 (armv5)
# This version is now unsupported using py311
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
# [numpy] <= 1.22.4 (armv7l)
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
WHEELS += src/requirements-crossenv-numpy-armv7l.txt
# [numpy] <= 1.24.4 last working version with gcc-4.9
else ifeq ($(call version_le, $(TC_GCC), 5.0),1)
WHEELS += src/requirements-crossenv-numpy-gcc4.txt
# [numpy] >= 1.25.0 requires c++17
else ifeq ($(call version_gt, $(TC_GCC), 5.0),1)
# BUG numpy==1.25.2 only on x86_64 gcc-8.5.0 DSM-7.1 -> Fallback to 1.25.1
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
WHEELS += src/requirements-crossenv-numpy-gcc85-x64.txt
else
WHEELS += src/requirements-crossenv-numpy.txt
endif
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
