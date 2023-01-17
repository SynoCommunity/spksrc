PKG_NAME = cffi
PKG_VERS = 1.11.5
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/c/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pycparser cross/libffi

HOMEPAGE = http://cffi.readthedocs.org
COMMENT  = Foreign Function Interface for Python calling C code
LICENSE  = MIT

include ../../mk/spksrc.python-module.mk
