PKG_NAME = gstreamer
PKG_VERS = 1.28.7
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gstreamer
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/glib

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer is a library for constructing graphs of media-handling components.
LICENSE  = LGPLv2.1

# meson project default c_std=gnu11
MIN_GCC_VERSION = 4.9

CONFIGURE_ARGS  = --wrap-mode=nodownload
CONFIGURE_ARGS += -Dpackage-origin=https://synocommunity.com
CONFIGURE_ARGS += -Dbash-completion=disabled
CONFIGURE_ARGS += -Dbenchmarks=disabled
CONFIGURE_ARGS += -Ddoc=disabled
CONFIGURE_ARGS += -Dexamples=disabled
CONFIGURE_ARGS += -Dintrospection=disabled
CONFIGURE_ARGS += -Dlibdw=disabled
CONFIGURE_ARGS += -Dlibunwind=disabled
CONFIGURE_ARGS += -Dtests=disabled
# gst-ptp-helper is written in Rust since 1.24
CONFIGURE_ARGS += -Dptp-helper=disabled

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk
