PKG_NAME = pip
# used to be the same version in native/python310|311/Makefile (python310|311_native_post_install)
# but this is now the last version of pip that can be installed using legacy setup.py
PKG_VERS = 23.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://pip.pypa.io
COMMENT  = The PyPA recommended tool for installing Python packages
LICENSE  = MIT

include ../../mk/spksrc.python-module.mk
