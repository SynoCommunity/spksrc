PKG_NAME = pygobject
PKG_VERS = 3.56.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/pygobject
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://pygobject.gnome.org/
COMMENT  = PyGObject is a Python package which provides bindings for GObject based libraries such as GTK, GStreamer, WebKitGTK, GLib, GIO and many more.
LICENSE  = LGPLv2.1+

# needs glib >= 2.80, i.e. cross/glib-latest, which declares gcc 7.5; below that
# the glib virtual offers 2.66 and meson stops on
#   Dependency 'glib-2.0' ... found '2.66.x' but need '>= 2.80.0'
MIN_GCC_VERSION = 7.5

DEPENDS += python/pycairo

include ../../mk/spksrc.python-wheel-meson.mk
