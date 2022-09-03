PKG_NAME = gst-omx
PKG_VERS = 1.20.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-omx
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

#DEPENDS  = cross/glib
DEPENDS += cross/realtek-omx
DEPENDS += cross/gstreamer
DEPENDS += cross/gst-plugins-base

HOMEPAGE = https://github.com/GStreamer/gst-omx
COMMENT  = This plugin wraps available OpenMAX IL components and makes them available as standard GStreamer elements.
LICENSE  = LGPLv2.1

CONFIGURE_ARGS += -Ddoc=disabled
#CONFIGURE_ARGS += -Dexamples=disabled
CONFIGURE_ARGS += -Dtarget=generic

# Require access to glib-mkenums Python script
#ENV += PATH=$(STAGING_INSTALL_PREFIX)/bin:$$PATH

#include ../../mk/spksrc.common.mk

#ADDITIONAL_CFLAGS = -std=c99
#ADDITIONAL_CFLAGS += -D_XOPEN_SOURCE=600

#ifeq ($(call version_lt, $(call version_gcc), 5),1)
#ADDITIONAL_CFLAGS += -D_GNU_SOURCE
#endif

include ../../mk/spksrc.cross-meson.mk
