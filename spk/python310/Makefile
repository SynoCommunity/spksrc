SPK_NAME = python310
SPK_VERS = 3.10.0
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 4
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
# Mandatory binaries for wheel
# setup during package install
DEPENDS += cross/setuptools cross/pip cross/wheel

# Required for lxml wheel
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt

# Required for PyYAML
DEPENDS += cross/libyaml

# Required for pycurl wheel
DEPENDS += cross/curl
ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

# Required for PyNaCl
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# Patched cross-compiled wheel
# https://github.com/python-pillow/Pillow/issues/5799
# Moved to individual packages, uncoment to enable
# DEPENDS += cross/pillow

# Required for pycares
DEPENDS += cross/c-ares
ENV += PYCARES_USE_SYSTEM_LIB=1

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

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
