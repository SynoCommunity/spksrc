PKG_NAME = libsigc++
PKG_SHORT_VERS = 2.12
PKG_VERS = $(PKG_SHORT_VERS).0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# support for c++11 language features is required
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

DEPENDS =

HOMEPAGE = http://libsigc.sourceforge.net/
COMMENT  = libsigc++ implements a typesafe callback system for standard C++
LICENSE  = LGPL

include ../../mk/spksrc.cross-meson.mk
