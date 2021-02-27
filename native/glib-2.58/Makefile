PKG_NAME = glib
PKG_VERS = 2.58.3
PKG_SHORT_VERS=$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnome.org/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)

DEPENDS =

HOMEPAGE = https://developer.gnome.org/glib/
COMMENT  = General-purpose utility library
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = glib_pre_configure

include ../../mk/spksrc.native-cc.mk

.PHONY: glib_pre_configure
glib_pre_configure: 
	# force autogen to first use internal pcre instead of provided to prevent
	# build failure. Subsequent default configure will superseed this afterwards
	$(RUN) ./autogen.sh
