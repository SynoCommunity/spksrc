PKG_NAME = pygobject
PKG_VERS = 3.50.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://files.pythonhosted.org/packages/source/p/pygobject
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://pygobject.gnome.org/
COMMENT  = PyGObject is a Python package which provides bindings for GObject based libraries such as GTK, GStreamer, WebKitGTK, GLib, GIO and many more.
LICENSE  = LGPLv2.1+

# PyGObject versions >= 3.51.0 require girepository-2.0 for introspection
# GIRepository-2.0 is a component of GObject Introspection >= 1.80.0
# GObject Introspection >= 1.79.0 requires GLib >= 2.79

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k evansport

DEPENDS  = cross/gobject-introspection
DEPENDS += python/pycairo

include ../../mk/spksrc.python-wheel-meson.mk
