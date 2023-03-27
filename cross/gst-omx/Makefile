PKG_NAME = gst-omx
PKG_VERS = 1.20.5
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
CONFIGURE_ARGS += -Dheader_path=$(STAGING_INSTALL_PREFIX)/include/omx/khronos
CONFIGURE_ARGS += -Dtarget=generic

# Link in to realtek libraries
ADDITIONAL_LDFLAGS = -Wl,--rpath-link,$(STAGING_INSTALL_PREFIX)/lib/realtek -Wl,--rpath,$(INSTALL_PREFIX)/lib/realtek

POST_EXTRACT_TARGET = gst-omx_post_extract

include ../../mk/spksrc.cross-meson.mk

.PHONY: gst-omx_post_extract
gst-omx_post_extract:
	mkdir $(WORK_DIR)/$(PKG_DIR)/config/realtek
	cp $(STAGING_INSTALL_PREFIX)/etc/gstomx.conf $(WORK_DIR)/$(PKG_DIR)/config/realtek
	echo "install_data (['gstomx.conf'], install_dir : omx_conf_dir)" > $(WORK_DIR)/$(PKG_DIR)/config/realtek/meson.build
