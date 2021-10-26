SPK_NAME = python39
SPK_VERS = 3.9.7
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 1
SPK_ICON = src/python3.png

DEPENDS  = cross/$(SPK_NAME)
DEPENDS += cross/bcrypt
DEPENDS += cross/libffi
DEPENDS += cross/openssl
DEPENDS += cross/libxml2
DEPENDS += cross/libxslt
DEPENDS += cross/curl
DEPENDS += cross/libyaml
DEPENDS += cross/sqlite

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

POST_STRIP_TARGET = python38_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: python38_extra_install
python38_extra_install:
	rm -f $(STAGING_DIR)/$(PYTHON_LIB_DIR)/config/libpython*.a
	rm -rf $(STAGING_DIR)/$(PYTHON_LIB_DIR)/test/
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' | xargs rm -f
