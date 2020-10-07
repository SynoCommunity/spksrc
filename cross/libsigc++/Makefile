PKG_NAME = libsigc++
PKG_SHORT_VERS = 2.10
PKG_VERS = $(PKG_SHORT_VERS).3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# support for C++11 language features is required
# Last supported version 2.4.1
UNSUPPORTED_ARCHS = 88f6281

DEPENDS =

HOMEPAGE = http://libsigc.sourceforge.net/
COMMENT  = libsigc++ implements a typesafe callback system for standard C++
LICENSE  = LGPL

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk

