PKG_NAME = numpy
PKG_VERS = 2.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/n/numpy
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://numpy.org/
COMMENT  = NumPy is the fundamental package for scientific computing with Python.
LICENSE  = NumPy Developers

WHEELS_BUILD_ARGS = --config-settings=setup-args="--cross-file=$(WORK_DIR)/tc_vars.meson"

MESON_PYTHON = 1

## https://numpy.org/devdocs/building/cross_compilation.html
## [properties]
## longdouble_format = 'IEEE_DOUBLE_LE'

include ../../mk/spksrc.python-wheel-meson.mk
