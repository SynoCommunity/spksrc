PKG_NAME = libjpeg
PKG_VERS = 9f
PKG_EXT = tar.gz
PKG_DIST_NAME = jpegsrc.v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.ijg.org/files
PKG_DIR = jpeg-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.ijg.org/
COMMENT  = JPEG library
LICENSE  = Custom BSD-like (free software)

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
