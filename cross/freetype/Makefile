PKG_NAME = freetype
PKG_VERS = 2.10.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/freetype
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libpng

HOMEPAGE = https://www.freetype.org
COMMENT  = FreeType is a freely available software library to render fonts.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-freetype-config

include ../../mk/spksrc.cross-cc.mk

