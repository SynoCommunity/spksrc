PKG_NAME = numpy_v1
PKG_SHORT_NAME = $(firstword $(subst _, ,$(PKG_NAME)))
PKG_VERS = 1.26.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_SHORT_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/n/numpy
PKG_DIR = $(PKG_SHORT_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://numpy.org/
COMMENT  = NumPy is the fundamental package for scientific computing with Python.
LICENSE  = NumPy Developers

# Requires gcc>=8.4 to build sucesfully
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

include ../../mk/spksrc.python-wheel-meson.mk
