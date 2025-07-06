PKG_NAME = libass
PKG_VERS = 0.17.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libass/libass/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/fribidi cross/fontconfig
OPTIONAL_DEPENDS = cross/harfbuzz cross/harfbuzz_2

# harfbuzz
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
DEPENDS += cross/harfbuzz_2
else
DEPENDS += cross/harfbuzz
endif

HOMEPAGE = https://github.com/libass/libass
COMMENT  = libass is a portable subtitle renderer for the ASS/SSA (Advanced Substation Alpha/Substation Alpha) subtitle format.
LICENSE  = ICS

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
