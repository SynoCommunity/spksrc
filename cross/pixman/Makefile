PKG_NAME = pixman
PKG_VERS = 0.43.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.cairographics.org/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpng

HOMEPAGE = https://www.cairographics.org
COMMENT  = Pixman is a low-level software library for pixel manipulation, providing features such as image compositing and trapezoid rasterization.
LICENSE  = MIT

CONFIGURE_ARGS  = -Dgtk=disabled
CONFIGURE_ARGS += -Dtests=disabled

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
# disable "X86 MMX"
# avoid internal compiler error:
# ../pixman/pixman-mmx.c:3900:1: internal compiler error: Max. number of generated reload insns per insn is achieved (90)
CONFIGURE_ARGS += -Diwmmxt=disabled
endif

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-meson.mk
