PKG_NAME = bcrypt
PKG_VERS = 3.1.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/b/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/cffi

HOMEPAGE = https://github.com/pyca/bcrypt
COMMENT  = Modern password hashing for your software and your servers
LICENSE  = Apache 2.0

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

include ../../mk/spksrc.python-module.mk
