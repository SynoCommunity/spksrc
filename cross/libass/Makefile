PKG_NAME = libass
PKG_VERS = 0.17.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libass/libass/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/fribidi cross/fontconfig cross/harfbuzz cross/libunibreak

# harfbuzz
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = https://github.com/libass/libass
COMMENT  = libass is a portable subtitle renderer for the ASS/SSA (Advanced Substation Alpha/Substation Alpha) subtitle format.
LICENSE  = ICS

CONFIGURE_ARGS += -Dfontconfig=enabled
CONFIGURE_ARGS += -Dlibunibreak=enabled

include ../../mk/spksrc.cross-meson.mk
