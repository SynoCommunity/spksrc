PKG_NAME = libxml++
PKG_VERS = 2.36.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnome.org/pub/GNOME/sources/libxml++/2.36
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/glibmm

HOMEPAGE = http://libxmlplusplus.sourceforge.net/
COMMENT  = Libxml++ is a C++ wrapper for the libxml XML parser library
LICENSE  = LGPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
