PKG_NAME = gst-plugins-good
PKG_VERS = 1.28.7
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-good
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/gst-plugins-base

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer Good Plugins, a set of plugins considered to have good quality code, correct functionality and the preferred LGPL license.
LICENSE  = LGPLv2.1

# meson project default c_std=gnu11
MIN_GCC_VERSION = 4.9

CONFIGURE_ARGS  = --wrap-mode=nodownload
CONFIGURE_ARGS += -Dpackage-origin=https://synocommunity.com
# pre-generated orc sources are shipped, do not run the (cross-compiled) orcc
CONFIGURE_ARGS += -Dorc-compiler=disabled
CONFIGURE_ARGS += -Ddoc=disabled
CONFIGURE_ARGS += -Dexamples=disabled
CONFIGURE_ARGS += -Dtests=disabled
# headless: no display, sound server or camera
CONFIGURE_ARGS += -Daalib=disabled
CONFIGURE_ARGS += -Ddv=disabled
CONFIGURE_ARGS += -Ddv1394=disabled
CONFIGURE_ARGS += -Dgdk-pixbuf=disabled
CONFIGURE_ARGS += -Dgtk3=disabled
CONFIGURE_ARGS += -Djack=disabled
CONFIGURE_ARGS += -Dpulse=disabled
CONFIGURE_ARGS += -Dqt5=disabled
CONFIGURE_ARGS += -Dqt6=disabled
CONFIGURE_ARGS += -Drpicamsrc=disabled
CONFIGURE_ARGS += -Dshout2=disabled
CONFIGURE_ARGS += -Dwavpack=disabled
CONFIGURE_ARGS += -Dximagesrc=disabled
# libsoup is loaded at runtime by adaptivedemux2, not needed to build
CONFIGURE_ARGS += -Dsoup=disabled
CONFIGURE_ARGS += -Dv4l2-gudev=disabled
CONFIGURE_ARGS += -Dv4l2-libv4l2=disabled

DEPENDS += cross/bzip2
CONFIGURE_ARGS += -Dbz2=enabled

DEPENDS += cross/cairo
CONFIGURE_ARGS += -Dcairo=enabled

DEPENDS += cross/flac
CONFIGURE_ARGS += -Dflac=enabled

DEPENDS += cross/libjpeg
CONFIGURE_ARGS += -Djpeg=enabled

DEPENDS += cross/lame
CONFIGURE_ARGS += -Dlame=enabled

DEPENDS += cross/libcaca
CONFIGURE_ARGS += -Dlibcaca=enabled

DEPENDS += cross/mpg123
CONFIGURE_ARGS += -Dmpg123=enabled

DEPENDS += cross/nettle
CONFIGURE_ARGS += -Dhls-crypto=nettle

DEPENDS += cross/libpng
CONFIGURE_ARGS += -Dpng=enabled

DEPENDS += cross/speex
CONFIGURE_ARGS += -Dspeex=enabled

DEPENDS += cross/taglib
CONFIGURE_ARGS += -Dtaglib=enabled

DEPENDS += cross/twolame
CONFIGURE_ARGS += -Dtwolame=enabled

DEPENDS += cross/libvpx
CONFIGURE_ARGS += -Dvpx=enabled

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk
