PKG_NAME = gst-libav
PKG_VERS = 1.28.8
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-libav
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/gst-plugins-base
# libav* come from the ffmpeg meta (FFMPEG_PACKAGE in spk/gstreamer)
OPTIONAL_DEPENDS = cross/ffmpeg8

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer libav plugin: the FFmpeg decoders, encoders, demuxers and muxers as GStreamer elements.
LICENSE  = LGPLv2.1

# meson project default c_std=gnu11
MIN_GCC_VERSION = 4.9

CONFIGURE_ARGS  = --wrap-mode=nodownload
CONFIGURE_ARGS += -Dpackage-origin=https://synocommunity.com
CONFIGURE_ARGS += -Ddoc=disabled
CONFIGURE_ARGS += -Dtests=disabled

include ../../mk/spksrc.cross-meson.mk
