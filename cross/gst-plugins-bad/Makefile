PKG_NAME = gst-plugins-bad
PKG_VERS = 1.20.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-bad
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/gstreamer cross/gst-plugins-base cross/libxml2

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer is a library for constructing graphs of media-handling components.
LICENSE  = LGPLv2.1

ENV += PATH=$(WORK_DIR)/../../../native/glib/work-native/install/usr/local/bin:$$PATH

OPTIONAL_DEPENDS  = cross/frei0r
OPTIONAL_DEPENDS += cross/libass
OPTIONAL_DEPENDS += cross/libaom
#OPTIONAL_DEPENDS += cross/svt-hevc
OPTIONAL_DEPENDS += cross/libva
OPTIONAL_DEPENDS += cross/libva-utils
OPTIONAL_DEPENDS += cross/intel-vaapi-driver
OPTIONAL_DEPENDS += cross/intel-media-driver
#OPTIONAL_DEPENDS += cross/intel-media-sdk
OPTIONAL_DEPENDS += cross/x265

PLIST_TRANSFORM = grep -v -e TBD

CONFIGURE_ARGS += -Dgpl=enabled

include ../../mk/spksrc.common.mk

ADDITIONAL_CFLAGS = -std=c99

ifeq ($(call version_lt, $(call version_gcc), 5),1)
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
#CONFIGURE_ARGS += -Dvaapi=enabled
else
# libgstdvb.so only gets built on x64
CONFIGURE_ARGS += -Ddvb=disabled
PLIST_TRANSFORM += -e libgstdvb.so
PLIST_TRANSFORM += -e libgstva.so
endif

ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/frei0r
else
PLIST_TRANSFORM += -e libgstfrei0r.so
endif

# Newer libass requires harfbuzz which in turns requires c++ from gcc >= 4.8 (88f6281-6.1 = gcc-4.6.4)
ifeq ($(call version_ge, $(call version_gcc), 4.8),1)
DEPENDS += cross/libass
else
PLIST_TRANSFORM += -e libgstassrender.so
endif

ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARMv8_ARCHS) $(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
DEPENDS += cross/libaom
else
PLIST_TRANSFORM += -e libgstaom.so
endif

include ../../mk/spksrc.cross-meson.mk
