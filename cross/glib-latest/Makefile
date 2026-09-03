PKG_NAME = glib
PKG_VERS = 2.84.2
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/glib/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))

DEPENDS = cross/libffi cross/libiconv cross/pcre2 cross/zlib

HOMEPAGE = https://developer.gnome.org/glib/
COMMENT  = General-purpose utility library.
LICENSE  = LGPLv2.1+

# Only the 2008 PowerPC compiler (4.3.7) was ever excluded here. The real floor for
# glib 2.84 is far higher -- cross/glib only ever selects it from gcc 7.5 -- but that
# is the selector's business; this restates the exclusion that was here, nothing more.
MIN_GCC_VERSION = 4.6

# https://docs.gtk.org/glib/building.html
CONFIGURE_ARGS += -Dgtk_doc=false -Dman=false
CONFIGURE_ARGS += -Dtests=false
CONFIGURE_ARGS += -Dglib_debug=disabled
CONFIGURE_ARGS += -Dlibmount=disabled
CONFIGURE_ARGS += -Ddefault_library=shared
CONFIGURE_ARGS += -Dselinux=disabled

include ../../mk/spksrc.cross-meson.mk
