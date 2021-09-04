PKG_NAME = virtualenv
PKG_VERS = 15.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/v/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://pypi.python.org/pypi/virtualenv
COMMENT  = A tool for creating isolated virtual python environments.
LICENSE  = MIT

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%'

include ../../mk/spksrc.python-module.mk
