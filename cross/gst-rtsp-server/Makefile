PKG_NAME = gst-rtsp-server
PKG_VERS = 1.28.7
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-rtsp-server
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/gst-plugins-base
DEPENDS += cross/gst-plugins-good

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = RTSP server library based on GStreamer.
LICENSE  = LGPLv2.1

# meson project default c_std=gnu11
MIN_GCC_VERSION = 4.9

CONFIGURE_ARGS  = --wrap-mode=nodownload
CONFIGURE_ARGS += -Dpackage-origin=https://synocommunity.com
CONFIGURE_ARGS += -Ddoc=disabled
CONFIGURE_ARGS += -Dexamples=disabled
CONFIGURE_ARGS += -Dintrospection=disabled
CONFIGURE_ARGS += -Dtests=disabled

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk
