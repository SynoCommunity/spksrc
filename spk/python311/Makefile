SPK_NAME = python311
SPK_VERS = 3.11.11
SPK_VERS_MAJOR_MINOR = $(word 1,$(subst ., ,$(SPK_VERS))).$(word 2,$(subst ., ,$(SPK_VERS)))
SPK_REV = 10
SPK_ICON = src/python3.png

# Platform "powerpc-none-linux-gnuspe" with compiler "gcc" is not supported by the
# CPython core team, see https://peps.python.org/pep-0011/ for more information.
# And compiler must support std=c++11 (OlD_PPC_ARCHS fail, but ARMv5_ARCHS have no issue).
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS  = cross/python311
DEPENDS += cross/pip

MAINTAINER = SynoCommunity
DESCRIPTION = Python Programming Language.
DESCRIPTION_FRE = Language de programmation Python.
DESCRIPTION_SPN = Lenguaje de programación Python.
STARTABLE = no
DISPLAY_NAME = Python 3.11
CHANGELOG = "1. Update to Python 3.11.11<br/>2. Update all mandatory wheels"

HOMEPAGE = https://www.python.org
LICENSE  = PSF

# Force compiler LTO optimizations
ENV += PYTHON_OPTIMIZE=1

# Force building pure-python wheels
WHEELS_PURE_PYTHON_PACKAGING_ENABLE = 1
WHEELS = src/requirements-pure.txt

SERVICE_SETUP = src/service-setup.sh

PYTHON_LIB_DIR = lib/python$(SPK_VERS_MAJOR_MINOR)

POST_STRIP_TARGET = python311_extra_install

SPK_USR_LOCAL_LINKS = bin:bin/python3.11

include ../../mk/spksrc.spk.mk

.PHONY: python311_extra_install
python311_extra_install:
	@$(MSG) - Remove compiled files from __pycache__
	find $(STAGING_DIR)/$(PYTHON_LIB_DIR) -type f -regex '.*\.py[co]' -delete
