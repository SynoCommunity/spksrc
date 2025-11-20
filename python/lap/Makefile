PKG_NAME = lap
PKG_VERS = 0.5.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/l/lap
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/gatagat/lap
COMMENT  = lap is a linear assignment problem solver using Jonker-Volgenant algorithm for dense LAPJV or sparse LAPMOD matrices.
LICENSE  = BSD-2-Clause license

# Requires gcc>=8.4 to build sucesfully
REQUIRED_MIN_DSM = 7.1
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

DEPENDS  = python/numpy

include ../../mk/spksrc.python-wheel.mk
