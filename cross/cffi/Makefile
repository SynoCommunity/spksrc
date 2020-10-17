PKG_NAME = cffi
PKG_VERS = 1.14.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/c/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/pycparser cross/libffi

HOMEPAGE = http://cffi.readthedocs.org
COMMENT  = Foreign Function Interface for Python calling C code
LICENSE  = MIT

PLIST_TRANSFORM = sed -e 's%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%' -e 's%@PYTHON_VERSION@%$(SPK_SHORT_VERS)%'

include ../../mk/spksrc.python-module.mk
