PKG_NAME = gst-plugins-ugly
PKG_VERS = 1.28.7
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-ugly
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/gst-plugins-base

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer Ugly Plugins, a set of good-quality plugins that might pose distribution problems.
LICENSE  = LGPLv2.1/GPLv2

# meson project default c_std=gnu11
MIN_GCC_VERSION = 4.9

CONFIGURE_ARGS  = --wrap-mode=nodownload
CONFIGURE_ARGS += -Dpackage-origin=https://synocommunity.com
# pre-generated orc sources are shipped, do not run the (cross-compiled) orcc
CONFIGURE_ARGS += -Dorc-compiler=disabled
CONFIGURE_ARGS += -Ddoc=disabled
CONFIGURE_ARGS += -Dtests=disabled
CONFIGURE_ARGS += -Dgpl=enabled
CONFIGURE_ARGS += -Dcdio=disabled
CONFIGURE_ARGS += -Dsidplay=disabled

DEPENDS += cross/x264
CONFIGURE_ARGS += -Dx264=enabled

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk
