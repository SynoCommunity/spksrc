PKG_NAME = gst-omx
PKG_VERS = 1.20.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-omx
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS += cross/omx-realtek
DEPENDS += cross/gstreamer
DEPENDS += cross/gst-plugins-base

HOMEPAGE = https://github.com/GStreamer/gst-omx
COMMENT  = This plugin wraps available OpenMAX IL components and makes them available as standard GStreamer elements.
LICENSE  = LGPLv2.1

CONFIGURE_ARGS += -Ddoc=disabled
CONFIGURE_ARGS += -Dexamples=disabled
CONFIGURE_ARGS += -Dheader_path=$(WORK_DIR)/$(PKG_DIR)/omx/openmax
CONFIGURE_ARGS += -Dtarget=generic

# Link in to realtek librarie
ADDITIONAL_LDFLAGS = -Wl,--rpath-link,$(STAGING_INSTALL_PREFIX)/lib/realtek -Wl,--rpath,$(INSTALL_PREFIX)/lib/realtek

include ../../mk/spksrc.cross-meson.mk
