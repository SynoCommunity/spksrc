PKG_NAME = pango
PKG_VERS = 1.56.4
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/pango/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/fontconfig cross/cairo cross/glib
# avoid build of fribidi as subproject of pango
DEPENDS += cross/fribidi
DEPENDS += cross/harfbuzz

HOMEPAGE = https://pango.gnome.org/
COMMENT  = Pango is a library for layout and rendering of text, with an emphasis on internationalization.
LICENSE  = GPLv2

# pango 1.56 requires glib >= 2.82, cairo >= 1.18, harfbuzz >= 8.4.
# glib-latest carries the highest floor (gcc 7.5, glibc 2.9); cairo-latest
# and harfbuzz are gcc 4.8. Below this the virtual selects pango-1.50.
MIN_GCC_VERSION = 7.5
MIN_GLIBC_VERSION = 2.9

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk
