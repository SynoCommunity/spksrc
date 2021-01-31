SPK_NAME = python38
SPK_SHORT_VERS = 3.8
SPK_VERS = $(SPK_SHORT_VERS).7
SPK_REV = 1
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
DEPENDS += cross/setuptools cross/pip cross/wheel
DEPENDS += cross/cffi cross/bcrypt cross/sqlite
# Cross-compiled wheels
DEPENDS += cross/lxml cross/pycrypto cross/pycurl cross/pyyaml
DEPENDS += cross/msgpack-python cross/ruamel.yaml cross/immutables
DEPENDS += cross/cryptography

WHEELS = src/requirements.txt

MAINTAINER = Allan Clark
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Python 3.8
CHANGELOG = "Initial Python 3.8 release"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

SERVICE_SETUP = src/service-setup.sh

PYTHON_LIB_DIR = lib/python$(SPK_SHORT_VERS)

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

POST_STRIP_TARGET = python38_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: python38_extra_install
python38_extra_install:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -fr $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
	mkdir -p $(STAGING_DIR)/usr/bin
	ln -sf /usr/local/$(SPK_NAME)/bin/python3 $(STAGING_DIR)/usr/bin/python3
	ln -sf /usr/local/$(SPK_NAME)/bin/python3 $(STAGING_DIR)/usr/bin/python$(SPK_SHORT_VERS)
