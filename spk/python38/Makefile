SPK_NAME = python38
SPK_VERS = 3.8.13
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 7
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
DEPENDS += cross/setuptools cross/pip cross/wheel
# Cross-compiled wheels
DEPENDS += cross/bcrypt cross/cffi
DEPENDS += cross/cryptography cross/greenlet cross/immutables
DEPENDS += cross/lxml cross/msgpack-python
DEPENDS += cross/pycrypto cross/pycurl
DEPENDS += cross/pyyaml cross/ruamel.yaml cross/sqlite

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Langage de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.8
CHANGELOG = "1. Update to Python 3.8.13<br/>2. Update to OpenSSL 1.1.1o"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

SERVICE_SETUP = src/service-setup.sh

ENV += PYTHON_OPTIMIZE=1

PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python38_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: python38_extra_install
python38_extra_install:
	@$(MSG) - Remove static libpython
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config-$(SPK_VERS_MAJOR_MINOR)-*/libpython$(SPK_VERS_MAJOR_MINOR).a
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config-$(SPK_VERS_MAJOR_MINOR)-*/python.o
	@$(MSG) - Remove test folder
	rm -rf $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	@$(MSG) - Remove compiled files from __pycache__
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' -delete
