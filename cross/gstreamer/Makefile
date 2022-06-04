PKG_NAME = gstreamer
PKG_VERS = 1.20.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gstreamer
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = native/glib cross/glib

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer is a library for constructing graphs of media-handling components.
LICENSE  = BSD 2-Clause "Simplified" License

ENV += PATH=$(WORK_DIR)/../../../native/glib/work-native/install/usr/local/bin:$$PATH

include ../../mk/spksrc.cross-meson.mk
