PKG_NAME = harfbuzz
PKG_VERS = 2.6.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/$(PKG_NAME)/$(PKG_NAME)/releases/download/$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/harfbuzz/harfbuzz
COMMENT  = This is HarfBuzz, a text shaping library.
LICENSE  =

DEPENDS = cross/freetype cross/glib cross/fontconfig

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --enable-shared=yes --enable-gtk-doc-html=no --with-gnu-ld=yes --with-icu=no
CONFIGURE_ARGS += --with-pic --with-freetype=yes --with-fontconfig=yes --with-glib=yes --with-libstdc++=yes 

include ../../mk/spksrc.cross-cc.mk

