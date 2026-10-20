PKG_NAME = lap
PKG_VERS = 0.5.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/l/lap
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/gatagat/lap
COMMENT  = lap is a linear assignment problem solver using Jonker-Volgenant algorithm for dense LAPJV or sparse LAPMOD matrices.
LICENSE  = BSD-2-Clause license

# No floor of its own: python/numpy_1.26 is a required dependency and its
# gcc 8.4 propagates.
DEPENDS  = python/numpy_1.26

include ../../mk/spksrc.python-wheel.mk
