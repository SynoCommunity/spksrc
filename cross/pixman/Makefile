PKG_NAME = pixman
PKG_VERS = 0.46.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.cairographics.org/releases/
PKG_DIST_MIRRORS = https://ftp.osuosl.org/pub/blfs/conglomeration/pixman https://distfiles.macports.org/pixman
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng

HOMEPAGE = https://www.cairographics.org
COMMENT  = Pixman is a low-level software library for pixel manipulation, providing features such as image compositing and trapezoid rasterization.
LICENSE  = MIT

CONFIGURE_ARGS  = -Dgtk=disabled
CONFIGURE_ARGS += -Dtests=disabled

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-meson.mk
