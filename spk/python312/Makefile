SPK_NAME = python312
SPK_VERS = 3.12.7
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 1
SPK_ICON = src/python3.png

# Platform "powerpc-none-linux-gnuspe" with compiler "gcc" is not supported by the
# CPython core team, see https://peps.python.org/pep-0011/ for more information.
# And compiler must support std=c++11 (OlD_PPC_ARCHS fail, but ARMv5_ARCHS have no issue).
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS  = cross/python312
DEPENDS += cross/pip

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Language de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.12
CHANGELOG = "1. Initial Python 3.13.7 package release"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

# Force compiler LTO optimizations
ENV += PYTHON_OPTIMIZE=1

# Force building pure-python wheels
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1
WHEELS = src/requirements-pure.txt

SERVICE_SETUP = src/service-setup.sh

PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python312_extra_install

SPK_USR_LOCAL_LINKS = bin:bin/python3.12

include ../../mk/spksrc.spk.mk

.PHONY: python312_extra_install
python312_extra_install:
	@$(MSG) - Remove compiled files from __pycache__
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' -delete
