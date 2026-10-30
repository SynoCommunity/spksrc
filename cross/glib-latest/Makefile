PKG_NAME = glib
PKG_VERS = 2.90.1
PKG_EXT = tar.xz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://download.gnome.org/sources/glib/$(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))

DEPENDS = cross/libffi cross/libiconv cross/pcre2 cross/zlib

HOMEPAGE = https://developer.gnome.org/glib/
COMMENT  = General-purpose utility library.
LICENSE  = LGPLv2.1+

# cross/glib has only ever selected this line from gcc 7.5 (and kernel 3.2, which every
# gcc >= 7.5 toolchain satisfies), and the floor is real rather than historical: the
# installed gmacros.h of glib 2.90 reaches for g_macro__has_attribute(flag_enum) with no
# fallback define, so a consumer compiled without __has_attribute (gcc < 5) fails on
# glib's own header -- json-glib does, under -Werror=undef.
MIN_GCC_VERSION = 7.5
# gio-launch-desktop uses SOCK_CLOEXEC, which glibc has from 2.9 (ppc853x-5.2 has 2.8)
MIN_GLIBC_VERSION = 2.9

# https://docs.gtk.org/glib/building.html
CONFIGURE_ARGS += -Dgtk_doc=false -Dman=false
CONFIGURE_ARGS += -Dtests=false
CONFIGURE_ARGS += -Dglib_debug=disabled
CONFIGURE_ARGS += -Dlibmount=disabled
CONFIGURE_ARGS += -Ddefault_library=shared
CONFIGURE_ARGS += -Dselinux=disabled

include ../../mk/spksrc.cross-meson.mk
