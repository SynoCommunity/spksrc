PKG_NAME = glib
PKG_SHORT_VERS = 2.58
PKG_VERS = $(PKG_SHORT_VERS).3
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)

DEPENDS =

HOMEPAGE = http://developer.gnome.org/glib/
COMMENT  = General-purpose utility library
LICENSE  = GPLv2

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = glib_pre_configure

include ../../mk/spksrc.native-cc.mk

.PHONY: glib_pre_configure

glib_pre_configure: 
	# force autogen to first use internal pcre instead of provided to prevent
	# build failure.  Subsequent default configure will superseed this afterwards
	$(RUN) ./autogen.sh
