PKG_NAME = gst-plugins-bad
PKG_VERS = 1.20.5
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-bad
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/glib
DEPENDS += cross/gstreamer
DEPENDS += cross/gst-plugins-base
DEPENDS += cross/dssim
DEPENDS += cross/libwebp
DEPENDS += cross/libxml2
DEPENDS += cross/openjpeg

# curl build needs additional configuration for gnutls and libssh2
DEPENDS += cross/curl
export BUILD_CURL_WITH="gnutls libssh2 zstd"

OPTIONAL_DEPENDS  = cross/frei0r
OPTIONAL_DEPENDS += cross/libass
OPTIONAL_DEPENDS += cross/libaom
OPTIONAL_DEPENDS += cross/openh264
OPTIONAL_DEPENDS += cross/svt-hevc
OPTIONAL_DEPENDS += cross/libva
OPTIONAL_DEPENDS += cross/libva-utils
OPTIONAL_DEPENDS += cross/intel-vaapi-driver
OPTIONAL_DEPENDS += cross/intel-media-driver
OPTIONAL_DEPENDS += cross/x265

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer is a library for constructing graphs of media-handling components.
LICENSE  = LGPLv2.1

CONFIGURE_ARGS += -Dpackage-origin=https://synocommunity.com
CONFIGURE_ARGS += -Dgpl=enabled

ADDITIONAL_CFLAGS  = -std=c99
# For openh264
ADDITIONAL_CFLAGS += -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include/wels

# Require access to glib-mkenums Python script
ENV += PATH=$(STAGING_INSTALL_PREFIX)/bin:$$PATH

PLIST_TRANSFORM = grep -v -e TBD

include ../../mk/spksrc.common.mk

ifeq ($(call version_lt, $$TC_GCC, 5),1)
ADDITIONAL_CFLAGS += -D_GNU_SOURCE
endif

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/libvpx
DEPENDS += cross/x265
CONFIGURE_ARGS += -Dx265=enabled
else
PLIST_TRANSFORM += -e libgstvpx.so
PLIST_TRANSFORM += -e libgstx265.so
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
DEPENDS += cross/libva cross/libva-utils cross/intel-vaapi-driver cross/intel-media-driver
DEPENDS += cross/svt-hevc
else
# libgstdvb.so only gets built on x64
CONFIGURE_ARGS += -Ddvb=disabled
PLIST_TRANSFORM += -e libgstdvb.so
# x86_64 hardware acceleration specific
PLIST_TRANSFORM += -e libgstva.*.so
PLIST_TRANSFORM += -e libgstsvthevcenc.so
PLIST_TRANSFORM += -e libgstkms.so
endif

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/frei0r
else
PLIST_TRANSFORM += -e libgstfrei0r.so
endif

ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/openh264
else
PLIST_TRANSFORM += -e libgstopenh264.so
endif

ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARMv8_ARCHS) $(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
DEPENDS += cross/libaom
else
PLIST_TRANSFORM += -e libgstaom.so
endif

include ../../mk/spksrc.cross-meson.mk

ifeq ($(call version_le, $$TC_GCC, 4.8),1)
# libass requires harfbuzz which in turns requires c++ from gcc >= 4.8 (88f6281-6.1 = gcc-4.6.4)
DEPENDS += cross/libass
else
PLIST_TRANSFORM += -e libgstassrender.so
endif
