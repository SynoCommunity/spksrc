PKG_NAME = pango
PKG_SHORT_VERS = 1.28
PKG_VERS = $(PKG_SHORT_VERS).4
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://ftp.acc.umu.se/pub/GNOME/sources/$(PKG_NAME)/$(PKG_SHORT_VERS)
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
