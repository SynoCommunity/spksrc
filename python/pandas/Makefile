PKG_NAME = pandas
# Moving to pandas>=3.x requires gcc>=11
# due to numpy genereted headers using newer API
PKG_VERS = 2.3.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/pandas
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://pandas.pydata.org/
COMMENT  = Fast, powerful, flexible and easy to use open source data analysis and manipulation tool
LICENSE  = 3-Clause BSD license

# Documentation: https://pandas.pydata.org/docs/dev/development/contributing_environment.html

# Numpy dependency requires gcc>=8.4 to build sucesfully
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k

OPTIONAL_DEPENDS  = python/numpy
OPTIONAL_DEPENDS  = python/numpy-latest

# On older python 3.10/3.11 keep using numpy 2.2.x
ifneq ($(filter %310 %311,$(PYTHON_PACKAGE)),)
DEPENDS  = python/numpy
else
DEPENDS  = python/numpy-latest
endif

include ../../mk/spksrc.python-wheel-meson.mk
