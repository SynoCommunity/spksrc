PKG_NAME = pango
PKG_VERS = 1.28.4
PKG_MAIN_VERS=$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.acc.umu.se/pub/GNOME/sources/$(PKG_NAME)/$(PKG_MAIN_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fontconfig cross/cairo cross/glib

HOMEPAGE = https://pango.gnome.org/
COMMENT  = Pango is a library for layout and rendering of text, with an emphasis on internationalization.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --prefix=$(STAGING_INSTALL_PREFIX)

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-cc.mk
