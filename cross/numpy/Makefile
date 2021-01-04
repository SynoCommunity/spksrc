PKG_NAME = numpy
PKG_VERS = 1.19.2
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/n/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/cython

HOMEPAGE = https://numpy.org/
COMMENT  = The fundamental package for scientific computing with Python
LICENSE  = https://numpy.org/doc/stable/license.html

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
# workaround for compiler bug, see: https://github.com/numpy/numpy/issues/13622
ADDITIONAL_CFLAGS += -O0
endif

include ../../mk/spksrc.python-wheel.mk

ifeq ($(PYTHON_LIB_NATIVE),$(PYTHON_LIB_CROSS))
LD_LIBRARY_PATH := $(INSTALL_DIR)$(INSTALL_PREFIX)/lib:$(LD_LIBRARY_PATH)
export LD_LIBRARY_PATH
endif
