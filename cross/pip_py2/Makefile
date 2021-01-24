PKG_NAME = pip
# only pip<21.0 is compatible with python2
PKG_VERS = 20.2.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://pip.pypa.io
COMMENT  = The PyPA recommended tool for installing Python packages
LICENSE  = MIT

include ../../mk/spksrc.python-module.mk
