PKG_NAME = gst-plugins-good
PKG_VERS = 1.20.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-good
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gstreamer cross/gst-plugins-base cross/lame

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer is a library for constructing graphs of media-handling components.
LICENSE  = LGPLv2.1

ENV += PATH=$(WORK_DIR)/../../../native/glib/work-native/install/usr/local/bin:$$PATH

include ../../mk/spksrc.common.mk

ADDITIONAL_CFLAGS = -std=c99

ifeq ($(call version_lt, $(call version_gcc), 5),1)
ADDITIONAL_CFLAGS += -D_GNU_SOURCE
endif

include ../../mk/spksrc.cross-meson.mk
