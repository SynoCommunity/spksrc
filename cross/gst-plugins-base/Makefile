PKG_NAME = gst-plugins-base
PKG_VERS = 1.28.7
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-base
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/gstreamer
DEPENDS += cross/libogg
DEPENDS += cross/libtheora
DEPENDS += cross/libvorbis
DEPENDS += cross/opus
DEPENDS += cross/orc
DEPENDS += cross/pango

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer Base Plugins, a well-groomed and well-maintained collection of GStreamer plugins and elements.
LICENSE  = LGPLv2.1

# meson project default c_std=gnu11
MIN_GCC_VERSION = 4.9

CONFIGURE_ARGS  = --wrap-mode=nodownload
CONFIGURE_ARGS += -Dpackage-origin=https://synocommunity.com
# pre-generated orc sources are shipped, do not run the (cross-compiled) orcc
CONFIGURE_ARGS += -Dorc-compiler=disabled
CONFIGURE_ARGS += -Ddoc=disabled
CONFIGURE_ARGS += -Dexamples=disabled
CONFIGURE_ARGS += -Dintrospection=disabled
CONFIGURE_ARGS += -Dtests=disabled
# headless: no display, sound card or optical drive
CONFIGURE_ARGS += -Dalsa=disabled
CONFIGURE_ARGS += -Dcdparanoia=disabled
CONFIGURE_ARGS += -Dgl=disabled
CONFIGURE_ARGS += -Dlibvisual=disabled
CONFIGURE_ARGS += -Dx11=disabled
CONFIGURE_ARGS += -Dxshm=disabled
CONFIGURE_ARGS += -Dxvideo=disabled
CONFIGURE_ARGS += -Dxi=disabled
CONFIGURE_ARGS += -Dqt5=disabled
CONFIGURE_ARGS += -Dtremor=disabled
CONFIGURE_ARGS += -Dogg=enabled
CONFIGURE_ARGS += -Dopus=enabled
CONFIGURE_ARGS += -Dorc=enabled
CONFIGURE_ARGS += -Dpango=enabled
CONFIGURE_ARGS += -Dtheora=enabled
CONFIGURE_ARGS += -Dvorbis=enabled

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk
