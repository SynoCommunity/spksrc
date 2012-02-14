PKG_NAME = Imaging
PKG_VERS = 1.1.7
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://effbot.org/downloads
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libjpeg

HOMEPAGE = http://www.pythonware.com/products/pil/
COMMENT  = Image processing capabilities for Python
LICENSE  = http://www.pythonware.com/products/pil/license.htm

ENV += STAGING_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.python-module.mk

