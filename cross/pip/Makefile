PKG_NAME = pip
# use the same version in native/python3/Makefile (python3_native_post_install)
PKG_VERS = 22.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://pip.pypa.io
COMMENT  = The PyPA recommended tool for installing Python packages
LICENSE  = MIT

include ../../mk/spksrc.python-module.mk
