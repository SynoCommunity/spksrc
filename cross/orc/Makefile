PKG_NAME = orc
PKG_VERS = 0.4.44
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/orc
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://gitlab.freedesktop.org/gstreamer/orc
COMMENT  = Optimized Inner Loop Runtime Compiler, used by GStreamer to accelerate audio and video processing.
LICENSE  = BSD-2-Clause

# orc sets no c_std, and gcc older than 5 defaults to gnu89 (no for-loop declarations)
CONFIGURE_ARGS  = -Dc_std=gnu99
CONFIGURE_ARGS += -Dbenchmarks=disabled
CONFIGURE_ARGS += -Dexamples=disabled
CONFIGURE_ARGS += -Dhotdoc=disabled
CONFIGURE_ARGS += -Dorc-test=disabled
CONFIGURE_ARGS += -Dtests=disabled
CONFIGURE_ARGS += -Dtools=disabled

include ../../mk/spksrc.cross-meson.mk
