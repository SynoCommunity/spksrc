PKG_NAME = ffmpeg
PKG_VERS = 4.3.2
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = GPLv2

NASM_PATH=$(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin

CONFIGURE_ARGS = --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include"
CONFIGURE_ARGS += --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib"
CONFIGURE_ARGS += --extra-libs="-lxml2 -ldl" --pkg-config=/usr/bin/pkg-config --ranlib=$(RANLIB)
CONFIGURE_ARGS += --enable-cross-compile --enable-rpath --enable-pic
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --enable-gpl --enable-version3
CONFIGURE_ARGS += --enable-fontconfig --enable-avresample
CONFIGURE_ARGS += --disable-debug
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-doc

# Enable Synology specific -hls_seek_time option and other optimizations
CONFIGURE_ARGS += --extra-cflags=-DSYNO_VIDEOSTATION

# Compiler workaround to enable DTS-HD MA stream decoding
CONFIGURE_ARGS += --extra-cflags=-fno-if-conversion
# Synology default optimization
CONFIGURE_ARGS += --extra-cflags=-O3
# Remove some of the noise while compiling
CONFIGURE_ARGS += --extra-cflags=-Wno-deprecated-declarations

include ../../mk/spksrc.common.mk

OPTIONAL_DEPENDS  = native/nasm
OPTIONAL_DEPENDS += cross/json-c
OPTIONAL_DEPENDS += cross/libass
OPTIONAL_DEPENDS += cross/libaom
OPTIONAL_DEPENDS += cross/libvpx
OPTIONAL_DEPENDS += cross/svt-av1
OPTIONAL_DEPENDS += cross/svt-hevc
OPTIONAL_DEPENDS += cross/libva
OPTIONAL_DEPENDS += cross/libva-utils
OPTIONAL_DEPENDS += cross/intel-vaapi-driver
OPTIONAL_DEPENDS += cross/intel-media-driver
OPTIONAL_DEPENDS += cross/intel-media-sdk
OPTIONAL_DEPENDS += cross/x264
OPTIONAL_DEPENDS += cross/x265
OPTIONAL_DEPENDS += cross/shine

DEPENDS += cross/freetype
CONFIGURE_ARGS += --enable-libfreetype

DEPENDS += cross/fribidi
CONFIGURE_ARGS += --enable-libfribidi

DEPENDS += cross/lame
CONFIGURE_ARGS += --enable-libmp3lame

DEPENDS += cross/libbluray
CONFIGURE_ARGS += --enable-libbluray

DEPENDS += cross/speex
CONFIGURE_ARGS += --enable-libspeex

DEPENDS += cross/flac
DEPENDS += cross/libtheora
CONFIGURE_ARGS += --enable-libtheora

DEPENDS += cross/libvorbis
CONFIGURE_ARGS += --enable-libvorbis

DEPENDS += cross/gnutls
CONFIGURE_ARGS += --enable-gnutls

DEPENDS += cross/opus
CONFIGURE_ARGS += --enable-libopus

DEPENDS += cross/soxr
CONFIGURE_ARGS += --enable-libsoxr

DEPENDS += cross/opencore-amr
CONFIGURE_ARGS += --enable-libopencore-amrnb --enable-libopencore-amrwb

ifneq ($(findstring $(ARCH),$(OLD_PPC_ARCHS)),$(ARCH))
DEPENDS += cross/x264
CONFIGURE_ARGS += --enable-libx264

DEPENDS += cross/x265
CONFIGURE_ARGS += --enable-libx265

DEPENDS += cross/libvpx
CONFIGURE_ARGS += --enable-libvpx

DEPENDS += cross/shine
CONFIGURE_ARGS += --enable-libshine

# end ifneq $(OLD_PPC_ARCHS)
endif

DEPENDS += cross/libzmq
CONFIGURE_ARGS += --enable-libzmq


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

ifeq ($(findstring $(ARCH),evansport),$(ARCH))
# Compiling tvheadend for evansport requires #include synology.h
POST_INSTALL_TARGET = ffmpeg_post_install
# Hardware acceleration requires
# intelce-toolchain from the DSM toolkit
REQUIRE_TOOLKIT = 1
endif


ifeq ($(call version_lt, ${TCVERSION}, 7.0),1)
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(OLD_PPC_ARCHS)),$(ARCH))
# Newer libass requires harfbuzz which in turns requires c++ from gcc >= 4.8 (88f6281-6.1 = gcc-4.6.4)
DEPENDS += cross/libass
CONFIGURE_ARGS += --enable-libass
endif
endif

ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARMv8_ARCHS) $(i686_ARCHS) $(x64_ARCHS)),$(ARCH))
DEPENDS += cross/libaom
CONFIGURE_ARGS += --enable-libaom
endif

# Add SVT-AV1 codec to supported ARCH
# Patch for support from: https://github.com/OpenVisualCloud/SVT-AV1/tree/master/ffmpeg_plugin
ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARMv8_ARCHS) $(x64_ARCHS)),$(ARCH))
DEPENDS += cross/svt-av1
CONFIGURE_ARGS += --enable-libsvtav1
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
DEPENDS += cross/svt-hevc
CONFIGURE_ARGS += --enable-libsvthevc
endif

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --disable-neon --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --enable-neon --enable-thumb --disable-armv6 --disable-armv6t2 --disable-vfp --disable-armv5te --disable-yasm --disable-asm
ifneq ($(findstring $(ARCH),alpine),$(ARCH))
CONFIGURE_ARGS += --extra-cflags=-DSYNO_ALPINE_NEON
endif
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm64 --enable-neon --enable-thumb --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-asm
CONFIGURE_ARGS += --arch=ppc
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
CONFIGURE_ARGS += --cpu=e500v2
else
CONFIGURE_ARGS += --cpu=e500 --disable-altivec
endif
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
BUILD_DEPENDS += native/nasm
DEPENDS += cross/libva cross/libva-utils cross/intel-vaapi-driver cross/intel-media-driver cross/intel-media-sdk
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=x86_64 --enable-vaapi --enable-libmfx
endif

ifeq ($(findstring $(ARCH),evansport),$(ARCH))
BUILD_DEPENDS += native/nasm
ENV += PATH=$(NASM_PATH):$$PATH

DEPENDS += cross/json-c
CONFIGURE_ARGS += --arch=x86 --cpu=atom
CONFIGURE_ARGS += --disable-x86asm
CONFIGURE_ARGS += --extra-cflags=-fasm
CONFIGURE_ARGS += --extra-cflags=-std=c99
CONFIGURE_ARGS += --extra-cflags=-pedantic
CONFIGURE_ARGS += --extra-cflags=-I$(TOOLKIT_ROOT)/include/intelce-utilities
CONFIGURE_ARGS += --extra-cflags=-I$(TOOLKIT_ROOT)/include/intelce-utilities/linux_user
CONFIGURE_ARGS += --extra-ldflags=-L$(TOOLKIT_ROOT)/lib/intelce-utilities
CONFIGURE_ARGS += --extra-ldflags=-Wl,-rpath-link,$(TOOLKIT_ROOT)/lib
CONFIGURE_ARGS += --extra-ldflags=-Wl,-rpath-link,$(TOOLKIT_ROOT)/lib/intelce-utilities
# DISABLE
CONFIGURE_ARGS += --disable-decoder=h264_smd
CONFIGURE_ARGS += --disable-decoder=mpeg2video_smd
CONFIGURE_ARGS += --disable-decoder=mpeg4_smd
CONFIGURE_ARGS += --disable-decoder=vc1_smd
CONFIGURE_ARGS += --disable-decoder=wmv3_smd
# ENABLE
#CONFIGURE_ARGS += --extra-cflags=-DSYNO_EVANSPORT_SMD
#CONFIGURE_ARGS += --enable-libh264_smd --enable-smd

.PHONY: ffmpeg_post_install
ffmpeg_post_install:
	@install -m 644 $(WORK_DIR)/$(PKG_DIR)/synoconfig.h $(WORK_DIR)/install$(INSTALL_PREFIX)/include
endif
