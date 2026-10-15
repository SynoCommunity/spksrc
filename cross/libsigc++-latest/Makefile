PKG_NAME = libsigc++
PKG_SHORT_VERS = 3.4
PKG_VERS = $(PKG_SHORT_VERS).0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# support for c++17 language features is required
# Needs gcc >= 7.5: libsigc++ 3.x is C++17. The three arch lists this replaces were a
# proxy for it -- every one of their toolchains is below 7.5 -- and a list stops saying
# anything true once an overlay lifts the compiler.
MIN_GCC_VERSION = 7.5

DEPENDS =

HOMEPAGE = http://libsigc.sourceforge.net/
COMMENT  = libsigc++ implements a typesafe callback system for standard C++
LICENSE  = LGPL

include ../../mk/spksrc.cross-meson.mk
