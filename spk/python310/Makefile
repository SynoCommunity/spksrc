SPK_NAME = python310
SPK_VERS = 3.10.0
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 2
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
# Mandatory binaries for wheel
# setup during package install
DEPENDS += cross/setuptools cross/pip cross/wheel

# Required for misc wheels
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
DEPENDS += cross/libyaml

# Required for pycurl wheel
DEPENDS += cross/curl
ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

# Required for PyNaCl
DEPENDS += cross/libsodium
ENV += SODIUM_INSTALL=system

# Patched cross-compiled wheel
# https://github.com/python-pillow/Pillow/issues/5799
DEPENDS += cross/pillow

WHEELS = src/requirements.txt setuptools==58.3.0 pip==21.3.1 wheel==0.37.0 pure:appdirs==1.4.4 cross:bcrypt==3.2.0

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
