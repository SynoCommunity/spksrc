PKG_NAME = gst-plugins-bad
PKG_VERS = 1.28.7
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-bad
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/gst-plugins-base

OPTIONAL_DEPENDS  = cross/frei0r
OPTIONAL_DEPENDS += cross/openh264
OPTIONAL_DEPENDS += cross/svt-av1

HOMEPAGE = https://gstreamer.freedesktop.org/
COMMENT  = GStreamer Bad Plugins, a set of plugins that aren't up to par compared to the rest: close to good quality, but missing something.
LICENSE  = LGPLv2.1/GPLv2

# meson project default c_std=gnu11
MIN_GCC_VERSION = 4.9

include ../../mk/spksrc.common.mk

CONFIGURE_ARGS  = --wrap-mode=nodownload
CONFIGURE_ARGS += -Dpackage-origin=https://synocommunity.com
# pre-generated orc sources are shipped, do not run the (cross-compiled) orcc
CONFIGURE_ARGS += -Dorc-compiler=disabled
CONFIGURE_ARGS += -Ddoc=disabled
CONFIGURE_ARGS += -Dexamples=disabled
CONFIGURE_ARGS += -Dintrospection=disabled
CONFIGURE_ARGS += -Dtests=disabled
CONFIGURE_ARGS += -Dgpl=enabled
# headless: no display
CONFIGURE_ARGS += -Ddirectfb=disabled
CONFIGURE_ARGS += -Dgl=disabled
CONFIGURE_ARGS += -Dgtk3=disabled
CONFIGURE_ARGS += -Dvulkan=disabled
CONFIGURE_ARGS += -Dwayland=disabled
CONFIGURE_ARGS += -Dwpe=disabled
CONFIGURE_ARGS += -Dwpe2=disabled
CONFIGURE_ARGS += -Dx11=disabled
# vendor GPU stacks not available on Synology NAS (dlopen'ed at runtime)
CONFIGURE_ARGS += -Damfcodec=disabled
CONFIGURE_ARGS += -Dhip=disabled
CONFIGURE_ARGS += -Dnvcodec=disabled
# Intel acceleration is provided through the va plugin
CONFIGURE_ARGS += -Dmsdk=disabled
CONFIGURE_ARGS += -Dqsv=disabled
# SVT-HEVC is archived upstream, use x265 instead
CONFIGURE_ARGS += -Dsvthevcenc=disabled

DEPENDS += cross/libaom
CONFIGURE_ARGS += -Daom=enabled

DEPENDS += cross/libass
CONFIGURE_ARGS += -Dassrender=enabled

DEPENDS += cross/bzip2
CONFIGURE_ARGS += -Dbz2=enabled

DEPENDS += cross/chromaprint-fftw
CONFIGURE_ARGS += -Dchromaprint=enabled

DEPENDS += cross/curl
CONFIGURE_ARGS += -Dcurl=enabled

DEPENDS += cross/libxml2
CONFIGURE_ARGS += -Ddash=enabled
CONFIGURE_ARGS += -Dsmoothstreaming=enabled

DEPENDS += cross/fdk-aac
CONFIGURE_ARGS += -Dfdkaac=enabled

DEPENDS += cross/nettle
CONFIGURE_ARGS += -Dhls=enabled
CONFIGURE_ARGS += -Dhls-crypto=nettle

DEPENDS += cross/libde265
CONFIGURE_ARGS += -Dlibde265=enabled

DEPENDS += cross/openjpeg
CONFIGURE_ARGS += -Dopenjpeg=enabled

DEPENDS += cross/libsrt
CONFIGURE_ARGS += -Dsrt=enabled

DEPENDS += cross/libwebp
CONFIGURE_ARGS += -Dwebp=enabled

DEPENDS += cross/x265
CONFIGURE_ARGS += -Dx265=enabled

ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS += cross/frei0r
CONFIGURE_ARGS += -Dfrei0r=enabled
else
CONFIGURE_ARGS += -Dfrei0r=disabled
PLIST_TRANSFORM_SED_ARGS += -e '/libgstfrei0r\.so/d'
endif

ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/openh264
CONFIGURE_ARGS += -Dopenh264=enabled
else
CONFIGURE_ARGS += -Dopenh264=disabled
PLIST_TRANSFORM_SED_ARGS += -e '/libgstopenh264\.so/d'
endif

ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
DEPENDS += cross/svt-av1
CONFIGURE_ARGS += -Dsvtav1=enabled
else
CONFIGURE_ARGS += -Dsvtav1=disabled
PLIST_TRANSFORM_SED_ARGS += -e '/libgstsvtav1\.so/d'
endif

# libdrm and libva come from the synocli-videodriver meta
ifneq ($(and $(VIDEODRV_ON),$(filter $(ARCH),$(x64_ARCHS)),$(filter 1,$(call version_ge, $(TCVERSION), 6))),)
CONFIGURE_ARGS += -Dva=enabled
else
CONFIGURE_ARGS += -Dva=disabled
PLIST_TRANSFORM_SED_ARGS += -e '/libgstva/d'
endif

ifneq ($(strip $(PLIST_TRANSFORM_SED_ARGS)),)
PLIST_TRANSFORM = sed $(PLIST_TRANSFORM_SED_ARGS)
endif

# let it find glib-mkenums
ENV += "PATH=$(PATH):$(STAGING_INSTALL_PREFIX)/bin"

include ../../mk/spksrc.cross-meson.mk
