PKG_NAME = glib
PKG_VERS = 2.62.6
PKG_SHORT_VERS = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)

DEPENDS = 

HOMEPAGE = https://developer.gnome.org/glib/
COMMENT  = General-purpose utility library
LICENSE  = GPLv2

UNSUPPORTED_ARCHS = powerpc ppc824x ppc853x ppc854x

CONFIGURE_ARGS += -Dman=false -Dlibmount=false -Ddefault_library=shared -Dselinux=disabled

include ../../mk/spksrc.native-meson.mk
