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

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH), $(ARM8_ARCHES)),$(ARCH))
# workaround for compiler bug, see: https://github.com/numpy/numpy/issues/13622
ADDITIONAL_CFLAGS += -O0
endif

include ../../mk/spksrc.python-wheel.mk
