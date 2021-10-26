SPK_NAME = python39
SPK_VERS = 3.9.7
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 1
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
DEPENDS += cross/bcrypt
DEPENDS += cross/curl
DEPENDS += cross/cffi
DEPENDS += cross/libffi
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
DEPENDS += cross/libyaml
DEPENDS += cross/openssl
DEPENDS += cross/sqlite

# Required for pycurl wheel
ENV += PYCURL_CURL_CONFIG=$(STAGING_INSTALL_PREFIX)/bin/curl-config

# Required for pycrypto wheel
# on non 64-bit archs
ENV += cross_compiling=yes
ADDITIONAL_LDFLAGS = -L$(STAGING_INSTALL_PREFIX)/lib

WHEELS = src/requirements-cross.txt src/requirements.txt

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.9
CHANGELOG = "1. Initial release"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

SERVICE_SETUP = src/service-setup.sh

PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python39_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: python39_extra_install
python39_extra_install:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -rf $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
