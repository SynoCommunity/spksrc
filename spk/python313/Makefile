SPK_NAME = python313
SPK_VERS = 3.13.14
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 11
SPK_ICON = src/python3.png

# Needs C11 <stdatomic.h> (and C++11); gcc ships stdatomic.h >= 4.8
MIN_GCC_VERSION = 4.8

DEPENDS  = cross/python313

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Language de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.$(subst python3,,$(SPK_NAME))
CHANGELOG = "1. Update to Python 3.13.14"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

# Force compiler LTO optimizations
ENV += PYTHON_OPTIMIZE=1

# Force building pure-python wheels
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1
WHEELS = src/requirements-pure.txt

SERVICE_SETUP = src/service-setup.sh

PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = $(SPK_NAME)_extra_install

SPK_USR_LOCAL_LINKS = bin:bin/python3.$(subst python3,,$(SPK_NAME))

include ../../mk/spksrc.spk.mk

.PHONY: $(SPK_NAME)_extra_install
$(SPK_NAME)_extra_install:
	@$(MSG) \($(SPK_NAME)\) Remove compiled files from __pycache__
	@find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' -delete
