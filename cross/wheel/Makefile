PKG_NAME = wheel
PKG_VERS = 0.37.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/w/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/setuptools

HOMEPAGE = https://wheel.readthedocs.io/en/stable/
COMMENT  = Reference implementation of the Python wheel packaging standard, as defined in PEP 427.
LICENSE  = MIT

include ../../mk/spksrc.python-module.mk
