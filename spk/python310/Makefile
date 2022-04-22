SPK_NAME = python310
SPK_VERS = 3.10.4
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 9
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
DEPENDS += cross/pip

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.10
CHANGELOG = "1. Update to python 3.10.4 <br/>2. Update to OpenSSL 1.1.1n"

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

include ../../mk/spksrc.archs.mk

# [gevent]
# DEPENDS += cross/libev cross/c-ares
# ENV += GEVENTSETUP_EMBED_CARES=FALSE
# ENV += GEVENTSETUP_EMBED_LIBEV=FALSE

# [libtorrent]
# # cross/boost: archs lacking C++11 compiler (88f6281, hi3535 and ppc archs except QorIQ)
# UNSUPPORTED_ARCHS += $(ARM5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)
# # libtorrent > 2.x are DSM 7 only due to c++14 minimal requirement
# REQUIRED_MIN_DSM = 7.0
# # comcerto2k has older toolchain than other DSM 7 archs
# UNSUPPORTED_ARCHS += comcerto2k
# DEPENDS += cross/boost cross/geoip cross/libiconv
# BOOST_LIBRARIES += system python chrono random
# ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"
# ENV += BOOST_BUILD_PATH=$(WORK_DIR)/boost_1_78_0
# ENV += PATH=$(WORK_DIR)/boost_1_78_0:$(PATH)
# # Fails to build on evansport-7.0 but enabling
# # -fPIC allows it to go much further
# # https://github.com/arvidn/libtorrent/issues/6792
# WHEELS_BUILD_ARGS += [libtorrent]
# WHEELS_BUILD_ARGS += build_ext
# WHEELS_BUILD_ARGS += --b2-args=libtorrent-python-pic=on

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
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -rf $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
