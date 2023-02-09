PKG_NAME = gstreamer-vaapi
PKG_VERS = 1.20.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gstreamer-vaapi
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

include ../../mk/spksrc.common.mk

ifeq ($(call version_ge, ${TCVERSION}, 7.0),1)
DEPENDS = cross/libudev_219
else
DEPENDS = cross/libudev_204
endif

DEPENDS += cross/glib
DEPENDS += cross/libva
DEPENDS += cross/libva-utils
DEPENDS += cross/intel-vaapi-driver
DEPENDS += cross/intel-media-driver
DEPENDS += cross/gstreamer
DEPENDS += cross/gst-plugins-base
DEPENDS += cross/gst-plugins-bad

OPTIONAL_DEPENDS  = cross/libudev_204
OPTIONAL_DEPENDS  = cross/libudev_219

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer is a library for constructing graphs of media-handling components.
LICENSE  = LGPLv2.1

CONFIGURE_ARGS += -Dpackage-origin=https://synocommunity.com
CONFIGURE_ARGS += -Dwith_drm=yes
CONFIGURE_ARGS += -Dwith_x11=no
CONFIGURE_ARGS += -Dwith_glx=no
CONFIGURE_ARGS += -Dwith_wayland=no
CONFIGURE_ARGS += -Dwith_egl=no

# Require access to glib-mkenums Python script
ENV += PATH=$(STAGING_INSTALL_PREFIX)/bin:$$PATH

include ../../mk/spksrc.cross-meson.mk
