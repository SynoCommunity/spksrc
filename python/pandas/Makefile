PKG_NAME = pandas
PKG_VERS = 2.3.2
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

# Allows compatibility with numpy API 1.x / 2.x
DEPENDS  = python/numpy_1.26

include ../../mk/spksrc.python-wheel-meson.mk
