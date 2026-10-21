PKG_NAME = libsigc++
PKG_SHORT_VERS = 2.12
PKG_VERS = $(PKG_SHORT_VERS).0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# C++11 alias templates, which gcc parses from 4.7:
#   ../sigc++/type_traits.h:63: error: expected unqualified-id before 'using'
MIN_GCC_VERSION = 4.7

DEPENDS =

HOMEPAGE = http://libsigc.sourceforge.net/
COMMENT  = libsigc++ implements a typesafe callback system for standard C++
LICENSE  = LGPL

include ../../mk/spksrc.cross-meson.mk
