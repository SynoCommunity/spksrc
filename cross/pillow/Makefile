PKG_NAME = Pillow
PKG_VERS = 8.2.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/P/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/libjpeg cross/zlib

HOMEPAGE = https://python-pillow.org
COMMENT  = The friendly PIL fork
LICENSE  = https://github.com/python-pillow/Pillow/blob/master/LICENSE

ENV += STAGING_INSTALL_PREFIX=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.python-wheel.mk
