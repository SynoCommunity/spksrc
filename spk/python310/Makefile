SPK_NAME = python310
SPK_VERS = 3.10.6
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 11
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
DEPENDS += cross/pip

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.10
CHANGELOG = "1. Update to Python 3.10.6<br/>2. Update to OpenSSL 1.1.1q"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

SERVICE_SETUP = src/service-setup.sh

ENV += PYTHON_OPTIMIZE=1
PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python310_extra_install

SPK_USR_LOCAL_LINKS = bin:bin/python3.10

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt src/requirements-abi3.txt

# Force building pure-python wheels
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1

##
## All configurations below are optional and
## are provided to demonstrate how to build
## various wheels.  Uncoment to enable.
##

include ../../mk/spksrc.common.mk

# [gevent]
# DEPENDS += cross/libev cross/c-ares
# ENV += GEVENTSETUP_EMBED_CARES=FALSE
# ENV += GEVENTSETUP_EMBED_LIBEV=FALSE

# [libtorrent] 2.0.6
# # archs lacking C++14 (and c++1y) compiler (88f6281, hi3535 and ppc archs except QorIQ)
# UNSUPPORTED_ARCHS += $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)
# DEPENDS += cross/openssl cross/boost_1.78 cross/geoip
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
# # libtorrent > 2.x are DSM 7 only due to c++14 minimal requirement
# # Unless c++1y is fixed: https://github.com/arvidn/libtorrent/issues/6868
# REQUIRED_MIN_DSM = 7.0
# UNSUPPORTED_ARCHS += comcerto2k
# # ifeq ($(call version_lt, $(call version_gcc), 5.0),1)
# # WHEELS_BUILD_ARGS += --b2-args=cxxstd=1y
# # endif

# [libtorrent] 1.2.16
# # archs lacking C++11 compiler (88f6281, hi3535 and ppc archs except QorIQ)
# UNSUPPORTED_ARCHS += $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)
# DEPENDS += cross/openssl cross/boost_1.70 cross/geoip cross/libiconv
# BOOST_LIBRARIES += system python chrono random
# BOOST_BUILD_PATH=$(WORK_DIR)/boost_1_70_0
# ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"
# ENV += BOOST_BUILD_PATH="$(BOOST_BUILD_PATH)"
# ENV += PATH=$(BOOST_BUILD_PATH):$(PATH)
# WHEELS_BUILD_ARGS += [libtorrent]
# WHEELS_BUILD_ARGS += build_ext
# WHEELS_BUILD_ARGS += --b2-args=libtorrent-python-pic=on
# ifeq ($(findstring $(ARCH),$(32bit_ARCHS)),$(ARCH))
# WHEELS_BUILD_ARGS += --b2-args=address-model=32 --no-autoconf=address-model
# endif
# ifeq ($(call version_lt, $(call version_gcc), 5.0),1)
# WHEELS_BUILD_ARGS += --b2-args=cxxstd=11
# endif

# [lxml]
# DEPENDS += cross/libxml2
# DEPENDS += cross/libxslt

# [mysqlclient]
# DEPENDS += cross/mysql-connector-c cross/mariadb-connector-c
# ENV += MYSQLCLIENT_CFLAGS="$(CFLAGS) -I$(STAGING_INSTALL_PREFIX)/include/mysql -I$(STAGING_INSTALL_PREFIX)/include/mariadb -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR)"
# ENV += MYSQLCLIENT_LDFLAGS="$(LDFLAGS)"

# [numpy]
# # Last known working version: 1.21.5
# # gcc-4.6.4 failed with exit status 1
# # https://github.com/numpy/numpy/issues/20664
# UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

# [numpy]
# # Fix wheel building with older compilers
# ifeq ($(call version_lt, $(TC_GCC), 5.0),1)
# WHEELS_CPPFLAGS = [numpy] -std=c++0x
# # workaround for compiler bug:
# # https://github.com/numpy/numpy/issues/13622
# ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
# WHEELS_CFLAGS = [numpy] -O0
# endif
# endif

# [Pillow]
# DEPENDS += cross/freetype cross/libjpeg cross/zlib
# WHEELS_BUILD_ARGS += [Pillow]
# WHEELS_BUILD_ARGS += build_ext
# WHEELS_BUILD_ARGS += --disable-platform-guessing
# WHEELS_BUILD_ARGS += --enable-freetype
# WHEELS_BUILD_ARGS += --enable-jpeg
# WHEELS_BUILD_ARGS += --enable-zlib

# [pycares]
# DEPENDS += cross/c-ares
# ENV += PYCARES_USE_SYSTEM_LIB=1

# [pycurl]
# DEPENDS += cross/curl
# ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

# [PyNaCl]
# DEPENDS += cross/libsodium
# ENV += SODIUM_INSTALL=system

# [PyYAML]
# DEPENDS += cross/libyaml

include ../../mk/spksrc.spk.mk

.PHONY: python310_extra_install
python310_extra_install:
	@$(MSG) - Remove test folder
	rm -rf $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	@$(MSG) - Remove compiled files from __pycache__
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' -delete
