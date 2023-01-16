PKG_NAME = libpciaccess
PKG_VERS = 0.17
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://xorg.freedesktop.org/archive/individual/lib
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://gitlab.freedesktop.org/xorg/lib/libpciaccess
COMMENT  = Generic PCI access library.
LICENSE  = https://gitlab.freedesktop.org/xorg/lib/libpciaccess/-/blob/master/COPYING

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
