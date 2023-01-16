PKG_NAME = libxml++
PKG_VERS = 2.40.1
PKG_SHORT_VERS = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources//$(PKG_NAME)/$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/glibmm

HOMEPAGE = http://libxmlplusplus.sourceforge.net/
COMMENT  = Libxml++ is a C++ wrapper for the libxml XML parser library.
LICENSE  = LGPLv2+

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
