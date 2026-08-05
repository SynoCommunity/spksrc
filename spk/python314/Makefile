SPK_NAME = python314
SPK_VERS = 3.14.5
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 4
SPK_ICON = src/python3.png

# Needs C11 <stdatomic.h> (and C++11); gcc ships stdatomic.h >= 4.8
MIN_GCC_VERSION = 4.8

# Python 3.14 uses C11 atomics (<stdatomic.h>), which gcc ships from 4.9 on; the
# DSM 5.2 x86/x64 stock gcc is 4.7.3, so the capability gate lifts it to the overlay.
MIN_GCC_VERSION = 4.9

DEPENDS  = cross/python314

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Language de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.14
CHANGELOG = "1. Update to Python 3.14.5"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

# Force compiler LTO optimizations
ENV += PYTHON_OPTIMIZE=1

# Force building pure-python wheels
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1
WHEELS = src/requirements-pure.txt

SERVICE_SETUP = src/service-setup.sh

PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python314_extra_install

SPK_USR_LOCAL_LINKS = bin:bin/python3.14

include ../../mk/spksrc.spk.mk

.PHONY: python314_extra_install
python314_extra_install:
	@$(MSG) \($(SPK_NAME)\) Remove compiled files from __pycache__
	@find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' -delete
