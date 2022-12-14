SPK_NAME = python311
SPK_VERS = 3.11.0
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 1
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
DEPENDS += cross/pip

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.11
CHANGELOG = "Release Python 3.11.0"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

SERVICE_SETUP = src/service-setup.sh

ENV += PYTHON_OPTIMIZE=1
PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python311_extra_install

SPK_USR_LOCAL_LINKS = bin:bin/python3.10

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt src/requirements-abi3.txt

# Force building pure-python wheels
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1

##
## All configurations below are optional and
## are provided to demonstrate how to build
## various wheels.  Uncoment to enable.
##

# # [bcrypt]
# ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
# ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/

# # [cryptography]
# # To generate py36-abi3 limited API:
# DEPENDS += cross/cryptography
# # To generate py311-py311 regular build using src/requirements-crossenv.txt:
# # NOTE: It's not possible to build py36-abi3 limited API using pip due to PEP517
# ENV += PYO3_CROSS_LIB_DIR=$(STAGING_INSTALL_PREFIX)/lib/
# ENV += PYO3_CROSS_INCLUDE_DIR=$(STAGING_INSTALL_PREFIX)/include/

# # [gevent]
# DEPENDS += cross/libev cross/c-ares
# ENV += GEVENTSETUP_EMBED_CARES=FALSE
# ENV += GEVENTSETUP_EMBED_LIBEV=FALSE

# # [lxml]
# DEPENDS += cross/libxml2
# DEPENDS += cross/libxslt

# # [mysqlclient]
# DEPENDS += cross/mysql-connector-c cross/mariadb-connector-c
# ENV += MYSQLCLIENT_CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/mysql -I$(STAGING_INSTALL_PREFIX)/include/mariadb -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)"
# ENV += MYSQLCLIENT_LDFLAGS="$(LDFLAGS)"

# # [Pillow]
# DEPENDS += cross/freetype cross/libjpeg cross/zlib
# WHEELS_BUILD_ARGS += [Pillow]
# WHEELS_BUILD_ARGS += build_ext
# WHEELS_BUILD_ARGS += --disable-platform-guessing
# WHEELS_BUILD_ARGS += --enable-freetype
# WHEELS_BUILD_ARGS += --enable-jpeg
# WHEELS_BUILD_ARGS += --enable-zlib

# # [pycares]
# DEPENDS += cross/c-ares
# ENV += PYCARES_USE_SYSTEM_LIB=1

# # [pycurl]
# DEPENDS += cross/curl
# ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

# # [PyNaCl]
# DEPENDS += cross/libsodium
# ENV += SODIUM_INSTALL=system

# # [PyYAML]
# DEPENDS += cross/libyaml

include ../../mk/spksrc.common.mk

# # [libtorrent] - generic
# UNSUPPORTED_ARCHS += $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)
# DEPENDS += cross/openssl
# DEPENDS += cross/boost_1.78
# DEPENDS += cross/geoip
# BOOST_LIBRARIES += system python chrono random
# BOOST_BUILD_PATH=$(WORK_DIR)/boost_1_78_0
# ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"
# ENV += BOOST_BUILD_PATH="$(BOOST_BUILD_PATH)"
# ENV += PATH=$(BOOST_BUILD_PATH):$(PATH)
# WHEELS_BUILD_ARGS += [libtorrent]
# WHEELS_BUILD_ARGS += build_ext
# WHEELS_BUILD_ARGS += --b2-args=libtorrent-python-pic=on
# ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
# WHEELS_BUILD_ARGS += --b2-args=address-model=32 --no-autoconf=address-model
# endif

# # [libtorrent] 2.0.7
# # DSM7 only due to c++14 minimal requirement
# # Unless c++1y is fixed: https://github.com/arvidn/libtorrent/issues/6868
# # archs lacking C++14 compiler (88f6281, hi3535, PPC and comcerto2k)
# UNSUPPORTED_ARCHS += comcerto2k

# # [numpy] > 1.21.6
# # Last known working version: 1.21.6
# # gcc-4.6.4 failed with exit status 1
# # https://github.com/numpy/numpy/issues/20664
# UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

# # [numpy] > 1.22.4
# UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS)

include ../../mk/spksrc.spk.mk

# # [libtorrent]
# ifeq ($(call version_ge, ${TC_GCC}, 7.5),1)
# # [libtorrent] 2.0.7
# WHEELS += src/requirements-crossenv-DSM7.txt
# # Ensure build arguments matches boost_1.78
# WHEELS_CXXFLAGS += [libtorrent]
# WHEELS_CXXFLAGS += -D_GLIBCXX_USE_C99_MATH
# WHEELS_CXXFLAGS += -D_GLIBCXX_HAVE_OBSOLETE_ISNAN
# WHEELS_CXXFLAGS += -D_GLIBCXX_HAVE_OBSOLETE_ISINF
# else
# # [libtorrent] 1.2.17
# WHEELS += src/requirements-crossenv-DSM6.txt
# DEPENDS += cross/libiconv
# # Ensure build arguments matches boost
# WHEELS_BUILD_ARGS += --b2-args=cxxstd=11
# endif

# # [numpy]
# # Fix wheel building with older compilers
# ifeq ($(call version_le, ${TC_GCC}, 5.0),1)
# WHEELS_CPPFLAGS += [numpy] -std=c++0x
# # workaround for compiler bug:
# # https://github.com/numpy/numpy/issues/13622
# ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
# WHEELS_CFLAGS += [numpy] -O0
# endif
# endif

# # [pycryptodome]
# ifeq ($(call version_ge, ${TC_GCC}, 4.9),1)
# WHEELS_CFLAGS += [pycryptodome] -std=c11
# else
# WHEELS_CFLAGS += [pycryptodome] -std=c99
# endif

# # [pycryptodomex]
# ifeq ($(call version_ge, ${TC_GCC}, 4.9),1)
# WHEELS_CFLAGS += [pycryptodomex] -std=c11
# else
# WHEELS_CFLAGS += [pycryptodomex] -std=c99
# endif

.PHONY: python311_extra_install
python311_extra_install:
	@$(MSG) - Remove test folder
	rm -rf $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	@$(MSG) - Remove compiled files from __pycache__
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' -delete
