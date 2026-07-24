PKG_NAME = ffmpeg
PKG_VERS = 4.4.8
PKG_MINOR_VERS = $(firstword $(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = GPLv2

# ffmpeg4 still builds on ARMv5 with the stock compiler -- unlike ffmpeg5+, which
# need gcc 4.9. Declare that floor: 4.6.4 is exactly the gcc ARMv5 (88f6281) ships
# under DSM 6.2.4, so every 6.2.4 arch meets it and ARMv5 stays legacy (no overlay
# forced) while the requirement is still stated rather than left implicit.
MIN_GCC_VERSION = 4.6.4

include ../../mk/spksrc.common.mk

CONFIGURE_ARGS  = --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX)
# ffmpeg builds the compiler name from --cross-prefix as <prefix>gcc, ignoring the
# environment CC. With a gcc overlay the real compiler is <prefix>gcc-8.5, so
# cross-prefix alone would pick the stock gcc. Point --cc/--cxx at the selected
# compiler, read drift-proof from the work dir's baked tc_vars; empty in legacy mode
# (ARMv5's default here), giving exactly the stock name as before. Same read as the
# coherence guard in spksrc.common/tc-capability.mk.
_FF_GCC_SUFFIX = $(shell sed -n 's/^TC_GCC_SUFFIX *:= *//p' $(WORK_DIR)/tc_vars.mk 2>/dev/null)
CONFIGURE_ARGS += --cc=$(TC_PATH)$(TC_PREFIX)gcc$(_FF_GCC_SUFFIX)
CONFIGURE_ARGS += --cxx=$(TC_PATH)$(TC_PREFIX)g++$(_FF_GCC_SUFFIX)
CONFIGURE_ARGS += --pkg-config=/usr/bin/pkg-config
CONFIGURE_ARGS += --ranlib=$(RANLIB)
CONFIGURE_ARGS += --enable-cross-compile --enable-rpath --enable-pic
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --enable-gpl --enable-version3
CONFIGURE_ARGS += --enable-avresample
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-doc
ifeq ($(strip $(GCC_DEBUG_INFO)),1)
  CONFIGURE_ARGS += --enable-debug=3 --disable-stripping --assert-level=2 --enable-ftrapv --disable-optimizations
else
  CONFIGURE_ARGS += --extra-cflags=-O3
  CONFIGURE_ARGS += --disable-debug
  ifneq ($(findstring $(ARCH), $(ARMv5_ARCHS) $(i686_ARCHS)),$(ARCH))
    CONFIGURE_ARGS += --enable-lto
  endif
endif

# Must match $(SPK_REV) from spk/ffmpeg$(PKG_MINOR_VERS)/Makefile
CONFIGURE_ARGS += --extra-version=$(shell sed -n 's/^SPK_REV = \(.*\)/\1/p' $(WORK_DIR)/../../../spk/ffmpeg$(PKG_MINOR_VERS)/Makefile)

# Enable the Synology VideoStation compatibility code added by the
# SYNO-* patch series (hls_seek_time, smooth streaming, srt tags, ...)
CONFIGURE_ARGS += --extra-cflags=-DSYNO_VIDEOSTATION

# Compiler workaround to enable DTS-HD MA stream decoding
CONFIGURE_ARGS += --extra-cflags=-fno-if-conversion
# Remove some of the noise while compiling
CONFIGURE_ARGS += --extra-cflags=-Wno-deprecated-declarations

OPTIONAL_DEPENDS  = cross/chromaprint-fftw
OPTIONAL_DEPENDS += cross/dav1d
OPTIONAL_DEPENDS += cross/frei0r
OPTIONAL_DEPENDS += cross/libaom
OPTIONAL_DEPENDS += cross/libass
OPTIONAL_DEPENDS += cross/librabbitmq
OPTIONAL_DEPENDS += cross/librist
OPTIONAL_DEPENDS += cross/libvmaf_1.5
OPTIONAL_DEPENDS += cross/libvmaf_2.3
OPTIONAL_DEPENDS += cross/libzimg
OPTIONAL_DEPENDS += cross/openh264
OPTIONAL_DEPENDS += cross/rubberband
OPTIONAL_DEPENDS += cross/shine
OPTIONAL_DEPENDS += cross/snappy
OPTIONAL_DEPENDS += cross/svt-av1
OPTIONAL_DEPENDS += cross/svt-hevc

# Define x86asm
ifeq ($(findstring $(ARCH),$(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --x86asmexe=nasm

# Allow ASM on aarch64, disable on all others
else ifneq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-asm
endif

# build cario first, otherwise cross/cairo fails to build for x64-6.* arch
# It does not fail for x64-7.* when cario is prebuilt with videodriver.
# The failing seems related to parallel builds and occurs since cairo is built with meson
# due lacking videodriver build include path for cairo.
# cairo is dependency of harfbuzz, dependency of libass
DEPENDS = cross/cairo

ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/chromaprint-fftw
CONFIGURE_ARGS += --enable-chromaprint
endif

ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS += cross/frei0r
CONFIGURE_ARGS += --enable-frei0r
endif

DEPENDS += cross/gnutls
CONFIGURE_ARGS += --enable-gnutls

ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/libass
CONFIGURE_ARGS += --enable-libass
endif

DEPENDS += cross/libbluray
CONFIGURE_ARGS += --enable-libbluray

DEPENDS += cross/libcaca
CONFIGURE_ARGS += --enable-libcaca

ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/dav1d
CONFIGURE_ARGS += --enable-libdav1d
endif

DEPENDS += cross/codec2
CONFIGURE_ARGS += --enable-libcodec2

DEPENDS += cross/libdc1394
CONFIGURE_ARGS += --enable-libdc1394

DEPENDS += cross/fontconfig
CONFIGURE_ARGS += --enable-libfontconfig

DEPENDS += cross/freetype
CONFIGURE_ARGS += --enable-libfreetype

DEPENDS += cross/fribidi
CONFIGURE_ARGS += --enable-libfribidi

DEPENDS += cross/lame
CONFIGURE_ARGS += --enable-libmp3lame

DEPENDS += cross/opencore-amr
CONFIGURE_ARGS += --enable-libopencore-amrnb --enable-libopencore-amrwb

DEPENDS += cross/openjpeg
CONFIGURE_ARGS += --enable-libopenjpeg

DEPENDS += cross/opus
CONFIGURE_ARGS += --enable-libopus

ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/librabbitmq
CONFIGURE_ARGS += --enable-librabbitmq
endif

ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/librist
CONFIGURE_ARGS += --enable-librist
endif

ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS += cross/rubberband
CONFIGURE_ARGS += --enable-librubberband
endif

ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/shine
CONFIGURE_ARGS += --enable-libshine
endif

ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/snappy
CONFIGURE_ARGS += --enable-libsnappy
endif

DEPENDS += cross/soxr
CONFIGURE_ARGS += --enable-libsoxr

DEPENDS += cross/speex
CONFIGURE_ARGS += --enable-libspeex

DEPENDS += cross/libsrt
CONFIGURE_ARGS += --enable-libsrt

DEPENDS += cross/flac
DEPENDS += cross/libtheora
CONFIGURE_ARGS += --enable-libtheora

DEPENDS += cross/twolame
CONFIGURE_ARGS += --enable-libtwolame

ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
DEPENDS += cross/libvmaf_2.3
CONFIGURE_ARGS += --enable-libvmaf
else ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/libvmaf_1.5
CONFIGURE_ARGS += --enable-libvmaf
endif

DEPENDS += cross/libvorbis
CONFIGURE_ARGS += --enable-libvorbis

DEPENDS += cross/libvpx
CONFIGURE_ARGS += --enable-libvpx

DEPENDS += cross/libwebp
CONFIGURE_ARGS += --enable-libwebp

DEPENDS += cross/x264
CONFIGURE_ARGS += --enable-libx264

DEPENDS += cross/x265
CONFIGURE_ARGS += --enable-libx265

DEPENDS += cross/libxml2
CONFIGURE_ARGS += --enable-libxml2 --enable-demuxer=dash

ifeq ($(call version_ge, $(TC_GCC), 4.8),1)
DEPENDS += cross/libzimg
CONFIGURE_ARGS += --enable-libzimg
endif

DEPENDS += cross/libzmq
CONFIGURE_ARGS += --enable-libzmq

DEPENDS += cross/zvbi
CONFIGURE_ARGS += --enable-libzvbi

#
# fdk-acc is now considered compatible with (L)GPL.
# It requires --enable-nonfree if you're also using --enable-gpl
#
# https://en.wikipedia.org/wiki/Fraunhofer_FDK_AAC
# It was classified as free by Fedora after a review by the legal department at Red Hat.
# See also: http://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AAC#FDK_License
#
DEPENDS += cross/fdk-aac
CONFIGURE_ARGS += --enable-libfdk-aac --enable-nonfree

##
## ARCH SPECIFIC
##

ifneq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
DEPENDS += cross/openh264
CONFIGURE_ARGS += --enable-libopenh264
endif

# Add libaom to supported ARCH
ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARMv8_ARCHS) $(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
DEPENDS += cross/libaom
CONFIGURE_ARGS += --enable-libaom
endif

# Add SVT-AV1 codec to supported ARCH
ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARMv8_ARCHS) $(x64_ARCHS)),$(ARCH))
DEPENDS += cross/svt-av1
CONFIGURE_ARGS += --enable-libsvtav1
endif

# Add SVT-HEVC codec to x64
# Patch for support from:
# https://github.com/OpenVisualCloud/SVT-HEVC/tree/master/ffmpeg_plugin
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
DEPENDS += cross/svt-hevc
CONFIGURE_ARGS += --enable-libsvthevc
endif

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm
CONFIGURE_ARGS += --disable-neon
# Needed for libsrt
CONFIGURE_ARGS += --extra-ldflags="-lrt"
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm
CONFIGURE_ARGS += --enable-neon
CONFIGURE_ARGS += --enable-thumb
CONFIGURE_ARGS += --disable-armv5te
CONFIGURE_ARGS += --disable-armv6
CONFIGURE_ARGS += --disable-armv6t2
CONFIGURE_ARGS += --disable-vfp
ifeq ($(findstring $(ARCH),alpine),$(ARCH))
CONFIGURE_ARGS += --extra-cflags=-DSYNO_ALPINE_NEON
endif
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm64
CONFIGURE_ARGS += --enable-neon
CONFIGURE_ARGS += --enable-libdrm
CONFIGURE_ARGS += --enable-thumb
CONFIGURE_ARGS += --enable-v4l2-m2m
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=ppc
# ffmpeg4's v4l2 device builds fine on ARMv5's old kernel headers, but not on the
# PowerPC ones: the V4L2 multiplanar API (V4L2_CAP_VIDEO_CAPTURE_MPLANE,
# VIDEO_MAX_PLANES) it pulls in arrived in Linux 3.1, and the PPC toolchains ship
# 2.6.32. Keyed on the kernel the toolchain provides, scoped to PPC where it bites.
ifeq ($(call version_lt, $(TC_KERNEL), 3.1),1)
CONFIGURE_ARGS += --disable-indev=v4l2 --disable-outdev=v4l2
endif
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
CONFIGURE_ARGS += --cpu=e500v2
CONFIGURE_ARGS += --extra-libs=-latomic
else
CONFIGURE_ARGS += --cpu=e500 --disable-altivec
endif
endif

ifeq ($(findstring $(ARCH),evansport),$(ARCH))
CONFIGURE_ARGS += --arch=x86
CONFIGURE_ARGS += --cpu=atom
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=x86_64
CONFIGURE_ARGS += --enable-libdrm
CONFIGURE_ARGS += --enable-vaapi
ifeq ($(call version_gt, $(TC_GCC), 5),1)
CONFIGURE_ARGS += --enable-v4l2-m2m
endif

# libmfx and libvpl cannot be enabled together:
#   - libmfx (Intel MediaSDK) → Gen6 to Gen11, legacy, maintenance only
#   - libvpl (oneVPL) → Gen12+, no Synology NAS has that
CONFIGURE_ARGS += --enable-libmfx
#CONFIGURE_ARGS += --enable-libvpl

# Enable OpenCL and Vulkan acceleration
ifeq ($(call version_gt, $(TC_GCC), 5),1)
#CONFIGURE_ARGS += --enable-libglslang <<-- Uses older API
CONFIGURE_ARGS += --enable-opencl
CONFIGURE_ARGS += --enable-vulkan
endif

endif # ifeq x64_ARCHS

include ../../mk/spksrc.cross-cc.mk
