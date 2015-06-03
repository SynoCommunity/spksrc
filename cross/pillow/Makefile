PKG_NAME = Pillow
PKG_VERS = 2.8.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://pypi.python.org/packages/source/P/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libjpeg

HOMEPAGE = http://python-pillow.github.io/
COMMENT  = The friendly PIL fork
LICENSE  =

ENV += STAGING_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.python-module.mk
