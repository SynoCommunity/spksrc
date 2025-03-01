PKG_NAME = numpy_v2
PKG_SHORT_NAME = $(firstword $(subst _, ,$(PKG_NAME)))
PKG_VERS = 2.2.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_SHORT_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/n/numpy
PKG_DIR = $(PKG_SHORT_NAME)-$(PKG_VERS)

DEPENDS  = cross/openblas
CONFIGURE_ARGS  = -Dblas=OpenBLAS

HOMEPAGE = https://numpy.org/
COMMENT  = NumPy is the fundamental package for scientific computing with Python.
LICENSE  = NumPy Developers

# Requires gcc>=8.4 to build sucesfully
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

# Force using package provided meson
VENDOR_MESON = $(WORK_DIR)/$(PKG_DIR)/vendored-meson/meson/meson.py

include ../../mk/spksrc.python-wheel-meson.mk
