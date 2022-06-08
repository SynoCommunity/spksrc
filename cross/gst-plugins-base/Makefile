PKG_NAME = gst-plugins-base
PKG_VERS = 1.20.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-base
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/glib
DEPENDS += cross/gstreamer
DEPENDS += cross/libjpeg
DEPENDS += cross/libpng
DEPENDS += cross/libtheora
DEPENDS += cross/libvorbis
DEPENDS += cross/opus
DEPENDS += cross/pango

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer is a library for constructing graphs of media-handling components.
LICENSE  = LGPLv2.1

# Require access to glib-mkenums Python script
ENV += PATH=$(STAGING_INSTALL_PREFIX)/bin:$$PATH

include ../../mk/spksrc.common.mk

ADDITIONAL_CFLAGS = -std=c99
ADDITIONAL_CFLAGS += -D_XOPEN_SOURCE=600

ifeq ($(call version_lt, $(call version_gcc), 5),1)
ADDITIONAL_CFLAGS += -D_GNU_SOURCE
endif

include ../../mk/spksrc.cross-meson.mk
