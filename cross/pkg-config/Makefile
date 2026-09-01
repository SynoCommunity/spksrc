PKG_NAME = pkg-config
PKG_VERS = 0.29.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gitlab.freedesktop.org/pkg-config/pkg-config/-/archive/$(PKG_NAME)-$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib

HOMEPAGE = https://gitlab.freedesktop.org/pkg-config/pkg-config
COMMENT  = pkg-config is a helper tool used when compiling applications and libraries
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = pkg-config_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: pkg-config_pre_configure
pkg-config_pre_configure:
	@$(RUN) ; sed -i 's/^m4_copy(/m4_copy_force(/' glib/m4macros/glib-gettext.m4
	@$(RUN) ; NOCONFIGURE=1 ./autogen.sh
