PKG_NAME = ffmpeg
PKG_VERS = 5.1.10
PKG_MINOR_VERS = $(firstword $(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = GPLv2

# Needs C11 and working atomics -- gcc 4.9 or newer
MIN_GCC_VERSION = 4.9

include ../../mk/spksrc.common.mk

CONFIGURE_ARGS  = --target-os=linux --prefix=$(INSTALL_PREFIX)

# Every tool named, rather than derived from --cross-prefix, so each follows whichever
# overlay provides it. as, ld and dep_cc come from cc; --pkg-config is set below.
CONFIGURE_ARGS += --enable-cross-compile
CONFIGURE_ARGS += --cc=$(call tc,gcc)
CONFIGURE_ARGS += --cxx=$(call tc,g++)
CONFIGURE_ARGS += --ar=$(call tc,ar)
CONFIGURE_ARGS += --nm=$(call tc,nm)
CONFIGURE_ARGS += --ranlib=$(call tc,ranlib)
CONFIGURE_ARGS += --strip=$(call tc,strip)
CONFIGURE_ARGS += --pkg-config=$(call native,pkg-config)
CONFIGURE_ARGS += --enable-rpath
CONFIGURE_ARGS += --enable-pic
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --enable-gpl
CONFIGURE_ARGS += --enable-version3
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-doc
ifeq ($(strip $(GCC_DEBUG_INFO)),1)
  CONFIGURE_ARGS += --enable-debug=3
  CONFIGURE_ARGS += --disable-stripping
  CONFIGURE_ARGS += --assert-level=2
  CONFIGURE_ARGS += --enable-ftrapv
  CONFIGURE_ARGS += --disable-optimizations
else
  CONFIGURE_ARGS += --extra-cflags=-O3
  CONFIGURE_ARGS += --disable-debug
  ifeq ($(findstring $(ARCH), $(i686_ARCHS)),)
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

##
## Optional Dependencies
##

$(call depend,cross/chromaprint-fftw,--enable-chromaprint)
$(call depend,cross/codec2,--enable-libcodec2)
$(call depend,cross/dav1d,--enable-libdav1d)
$(call depend,cross/flac cross/libtheora,--enable-libtheora)
$(call depend,cross/fontconfig,--enable-libfontconfig)
$(call depend,cross/freetype,--enable-libfreetype)
$(call depend,cross/frei0r,--enable-frei0r)
$(call depend,cross/fribidi,--enable-libfribidi)
$(call depend,cross/gnutls,--enable-gnutls)
$(call depend,cross/lame,--enable-libmp3lame)
$(call depend,cross/libaom,--enable-libaom)
$(call depend,cross/libass,--enable-libass)
$(call depend,cross/libbluray,--enable-libbluray)
$(call depend,cross/libcaca,--enable-libcaca)
$(call depend,cross/libdc1394,--enable-libdc1394)
$(call depend,cross/librabbitmq,--enable-librabbitmq)
$(call depend,cross/librist,--enable-librist)
$(call depend,cross/libsrt,--enable-libsrt)
$(call depend,cross/libvmaf,--enable-libvmaf)
$(call depend,cross/libvorbis,--enable-libvorbis)
$(call depend,cross/libvpx,--enable-libvpx)
$(call depend,cross/libwebp,--enable-libwebp)
$(call depend,cross/libxml2,--enable-libxml2 --enable-demuxer=dash)
$(call depend,cross/libzimg,--enable-libzimg)
$(call depend,cross/libzmq,--enable-libzmq)
$(call depend,cross/opencore-amr,--enable-libopencore-amrnb --enable-libopencore-amrwb)
$(call depend,cross/openh264,--enable-libopenh264)
$(call depend,cross/openjpeg,--enable-libopenjpeg)
$(call depend,cross/opus,--enable-libopus)
$(call depend,cross/rubberband,--enable-librubberband)
$(call depend,cross/shine,--enable-libshine)
$(call depend,cross/snappy,--enable-libsnappy)
$(call depend,cross/soxr,--enable-libsoxr)
$(call depend,cross/speex,--enable-libspeex)
$(call depend,cross/svt-av1,--enable-libsvtav1)
$(call depend,cross/svt-hevc,--enable-libsvthevc)
$(call depend,cross/twolame,--enable-libtwolame)
$(call depend,cross/x264,--enable-libx264)
$(call depend,cross/x265,--enable-libx265)
$(call depend,cross/zvbi,--enable-libzvbi)

#
# fdk-acc is now considered compatible with (L)GPL.
# It requires --enable-nonfree if you're also using --enable-gpl
#
# https://en.wikipedia.org/wiki/Fraunhofer_FDK_AAC
# It was classified as free by Fedora after a review by the legal department at Red Hat.
# See also: http://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AAC#FDK_License
#
$(call depend,cross/fdk-aac,--enable-libfdk-aac --enable-nonfree)

##
## ARCH SPECIFIC
##

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm
CONFIGURE_ARGS += --enable-neon
CONFIGURE_ARGS += --enable-thumb
CONFIGURE_ARGS += --disable-armv5te
CONFIGURE_ARGS += --disable-armv6
CONFIGURE_ARGS += --disable-armv6t2
CONFIGURE_ARGS += --disable-vfp
endif

# ARMv7L (hi3535): Cortex-A9 but SOFT float -- arm-cortexa9-linux-gnueabi, which is why it
# has its own arch group instead of sitting with the hard-float ARMv7 ones. NEON uses the
# VFP register file, so --enable-neon with --disable-vfp was never a coherent pair here.
ifeq ($(findstring $(ARCH),$(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm
CONFIGURE_ARGS += --cpu=cortex-a9
CONFIGURE_ARGS += --disable-neon
CONFIGURE_ARGS += --disable-vfp
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm64
CONFIGURE_ARGS += --enable-neon
# libdrm comes from the videodriver meta
ifneq ($(VIDEODRV_ON),)
CONFIGURE_ARGS += --enable-libdrm
endif
CONFIGURE_ARGS += --enable-thumb
CONFIGURE_ARGS += --enable-v4l2-m2m
endif

# Every PowerPC toolchain here is e500v2 -- ppc853x and qoriq both declare -mcpu=8548
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=ppc
CONFIGURE_ARGS += --cpu=e500v2
CONFIGURE_ARGS += --extra-libs=-latomic
endif

ifeq ($(findstring $(ARCH),evansport),$(ARCH))
CONFIGURE_ARGS += --arch=x86
CONFIGURE_ARGS += --cpu=atom
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=x86_64

# The m2m API, not the compiler: configure tests V4L2_BUF_FLAG_LAST, which Linux grew in
# 4.2. The 3.x toolchains (x64-6.2.4: 3.10) ship headers without it and configure fails.
ifeq ($(call version_ge, $(TC_KERNEL), 4.2),1)
CONFIGURE_ARGS += --enable-v4l2-m2m
endif

# The videodriver meta's own floor: its kernel (spksrc.spk-meta/videodriver.mk)
ifeq ($(call version_ge, $(TC_KERNEL), 3.10),1)

# libdrm, libva, MediaSDK and the OpenCL/Vulkan set below all come from the videodriver
# meta; asking for them where it does not exist stops configure at "libmfx not found".
ifneq ($(VIDEODRV_ON),)
CONFIGURE_ARGS += --enable-libdrm
CONFIGURE_ARGS += --enable-vaapi

# libmfx and libvpl cannot be enabled together:
#   - libmfx (Intel MediaSDK) → Gen6 to Gen11, legacy, maintenance only
#   - libvpl (oneVPL) → Gen12+, no Synology NAS has that
CONFIGURE_ARGS += --enable-libmfx
#CONFIGURE_ARGS += --enable-libvpl

# Enable OpenCL and Vulkan acceleration: where the videodriver meta ships ocl-icd, the
# Vulkan loader and shaderc -- gcc 7.5, their C++17 floor (videodriver-depends.mk)
ifeq ($(call version_ge, $(TC_GCC), 7.5),1)
#CONFIGURE_ARGS += --enable-libglslang  # <-- Mutually exclusive to shaderc
CONFIGURE_ARGS += --enable-libshaderc
CONFIGURE_ARGS += --enable-opencl
CONFIGURE_ARGS += --enable-vulkan
endif

endif # ifneq VIDEODRV_ON
endif # ifeq TC_KERNEL >= 3.10
endif # ifeq x64_ARCHS

include ../../mk/spksrc.cross-cc.mk
