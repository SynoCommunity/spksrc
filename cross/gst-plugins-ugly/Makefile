PKG_NAME = gst-plugins-ugly
PKG_VERS = 1.20.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-ugly
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/gstreamer
DEPENDS += cross/gst-plugins-base
DEPENDS += cross/opencore-amr

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer is a library for constructing graphs of media-handling components.
LICENSE  = LGPLv2.1

# Require access to glib-mkenums Python script
ENV += PATH=$(STAGING_INSTALL_PREFIX)/bin:$$PATH

OPTIONAL_DEPENDS  = cross/x264

PLIST_TRANSFORM = grep -v -e TBD

CONFIGURE_ARGS += -Dgpl=enabled

include ../../mk/spksrc.common.mk

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/x264
CONFIGURE_ARGS += -Dx264=enabled
else
PLIST_TRANSFORM += -e libgstx264.so -e GstX264Enc.prs
endif

include ../../mk/spksrc.cross-meson.mk
