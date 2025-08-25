PKG_NAME = newt
PKG_VERS = 0.52.24
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://releases.pagure.org/newt
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/slang
DEPENDS += cross/popt

HOMEPAGE = https://pagure.io/newt
COMMENT  = Newt is a programming library for color text mode, widget based user interfaces.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

# Build Library and Package for Python 3.12
# Depends on prebuilt python.
include $(or $(wildcard $(WORK_DIR)/crossenv/build/python-cc.mk), $(wildcard $(PYTHON_PACKAGE_WORK_DIR)/crossenv/build/python-cc.mk))
PYTHON_NAME = $(basename $(notdir $(PYTHON_INTERPRETER)))
PYTHONVERS = python3.12
CONFIGURE_ARGS += --with-python=$(WORK_DIR)/../../../native/$(PYTHON_NAME)/work-native/install/usr/local/bin/$(PYTHON_NAME)
ADDITIONAL_CFLAGS += -I$(STAGING_INSTALL_PREFIX)/$(PYTHON_INC_DIR) -O

# let it find python*-configure
ENV += PATH=$$PATH:$(PYTHON_STAGING_INSTALL_PREFIX)/bin

CONFIGURE_ARGS  = --with-python=$(PYTHONVERS)
CONFIGURE_ARGS += --without-tcl

PRE_CONFIGURE_TARGET = newt_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: python_dependency
python_dependency:
ifneq ($(PYTHON_PACKAGE),python312)
	$(error "This package must be built withing PYTHON_PACKAGE for Python 3.12")
endif

.PHONY: newt_pre_configure
newt_pre_configure: python_dependency
	@$(RUN) ; ./autogen.sh
