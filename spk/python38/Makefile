SPK_NAME = python38
SPK_VERS = 3.8.12
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 6
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
DEPENDS += cross/setuptools cross/pip cross/wheel
# Cross-compiled wheels
DEPENDS += cross/bcrypt cross/cffi
DEPENDS += cross/cryptography cross/greenlet cross/immutables
DEPENDS += cross/lxml cross/msgpack-python
DEPENDS += cross/pycrypto cross/pycurl
DEPENDS += cross/pyyaml cross/ruamel.yaml cross/sqlite

WHEELS = src/requirements-cross.txt src/requirements.txt

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.8
CHANGELOG = "1. Update to Python 3.8.12<br/>2. Update OpenSSL to v1.1.1l<br/>3. Update included wheels"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

SERVICE_SETUP = src/service-setup.sh

ENV += PYTHON_OPTIMIZE=1

PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python38_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: python38_extra_install
python38_extra_install:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -rf $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
