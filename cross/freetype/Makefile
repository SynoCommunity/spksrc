PKG_NAME = freetype
PKG_VERS = 2.13.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://de.freedif.org/savannah/freetype
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libpng

HOMEPAGE = https://www.freetype.org
COMMENT  = FreeType is a freely available software library to render fonts.
LICENSE  = GPLv2

ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-meson.mk
