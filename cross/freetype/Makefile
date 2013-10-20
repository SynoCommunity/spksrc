PKG_NAME = freetype
PKG_VERS = 2.5.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://download.savannah.gnu.org/releases/freetype/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = http://www.freetype.org/
COMMENT  = FreeType is a freely available software library to render fonts. 
LICENSE  = GPL2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --without-png 

PRE_CONFIGURE_TARGET = myPreConfigure

include ../../mk/spksrc.cross-cc.mk
