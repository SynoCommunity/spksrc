PKG_NAME = gstreamer-vaapi
PKG_VERS = 1.20.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gstreamer-vaapi
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/glib
DEPENDS += cross/intel-media-driver
DEPENDS += cross/intel-vaapi-driver
DEPENDS += cross/gstreamer
DEPENDS += cross/gst-plugins-base
#DEPENDS += cross/gst-plugins-good
DEPENDS += cross/gst-plugins-bad
#DEPENDS += cross/gst-plugins-ugly

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer is a library for constructing graphs of media-handling components.
LICENSE  = LGPLv2.1

# Require access to glib-mkenums Python script
ENV += PATH=$(STAGING_INSTALL_PREFIX)/bin:$$PATH

include ../../mk/spksrc.cross-meson.mk
