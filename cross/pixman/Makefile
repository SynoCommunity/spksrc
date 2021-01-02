PKG_NAME = pixman
PKG_VERS = 0.38.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.cairographics.org/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng

HOMEPAGE = https://www.cairographics.org
COMMENT  = Pixman is a low-level software library for pixel manipulation, providing features such as image compositing and trapezoid rasterization.
LICENSE  = MIT

CONFIGURE_ARGS = -Dgtk=disabled

include ../../mk/spksrc.archs.mk

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += -Diwmmxt=disabled
endif

include ../../mk/spksrc.cross-meson.mk
