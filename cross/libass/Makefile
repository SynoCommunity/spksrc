PKG_NAME = libass
PKG_VERS = 0.13.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libass/libass/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/freetype cross/fribidi cross/fontconfig

HOMEPAGE = https://github.com/libass/libass
COMMENT  = libass is a portable subtitle renderer for the ASS/SSA (Advanced Substation Alpha/Substation Alpha) subtitle format.
LICENSE  = ICS

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

