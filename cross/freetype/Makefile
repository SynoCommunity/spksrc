PKG_NAME = freetype
PKG_VERS = 2.12.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.savannah.gnu.org/releases/freetype
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libpng

HOMEPAGE = https://www.freetype.org
COMMENT  = FreeType is a freely available software library to render fonts.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
# avoid the build of freetype-config 
# - it has wrong prefixes in it
# - dependents must use freetype2.pc instead
# - when there are dependents that must have freetype-config, 
#   we could enable this, but must fix the prefixes (our framework does an adjustment for *.pc files only)
# - as it is not as easy to adjust the prefixes as in cross/libxml2 we disable it here
CONFIGURE_ARGS  = --disable-freetype-config
CONFIGURE_ARGS += --disable-static
ADDITIONAL_CPPFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
