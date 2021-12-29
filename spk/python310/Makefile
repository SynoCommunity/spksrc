SPK_NAME = python310
SPK_VERS = 3.10.0
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 5
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
# Mandatory binaries for wheel
# setup during package install
DEPENDS += cross/setuptools cross/pip cross/wheel

##
## All configurations below are optional and
## are provided to demonstrate how to build
## various wheels.  Uncoment to enable.
##

# [wheel] Required for lxml
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# [wheel] Required for PyYAML
DEPENDS += cross/libyaml

# [wheel] Required for pycurl
DEPENDS += cross/curl
ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

# [wheel] Required for PyNaCl
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# [wheel] Required for Pillow
DEPENDS += cross/freetype cross/libjpeg cross/zlib
WHEELS_BUILD_ARGS += [Pillow]
WHEELS_BUILD_ARGS += build_ext
WHEELS_BUILD_ARGS += --disable-platform-guessing
WHEELS_BUILD_ARGS += --enable-freetype
WHEELS_BUILD_ARGS += --enable-jpeg
WHEELS_BUILD_ARGS += --enable-zlib

# [wheel] Required for pycares
DEPENDS += cross/c-ares
ENV += PYCARES_USE_SYSTEM_LIB=1

include ../../mk/spksrc.common.mk

# [wheel] numpy -> gcc-4.6.4 failed with exit status 1
# https://github.com/numpy/numpy/issues/20664
# UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

# [wheel] Fix numpy wheel compilation with older compilers
ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
WHEELS_CPPFLAGS = [numpy] -std=c++0x
ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
WHEELS_CFLAGS = [numpy] -O0
endif
endif

# Force building pure-python wheels
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt src/requirements-abi3.txt

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.10
CHANGELOG = "1. Initial release"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

SERVICE_SETUP = src/service-setup.sh

ENV += PYTHON_OPTIMIZE=1

PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python310_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: python310_extra_install
python310_extra_install:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -rf $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
