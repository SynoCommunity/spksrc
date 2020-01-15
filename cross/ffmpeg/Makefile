PKG_NAME = ffmpeg
PKG_VERS = 4.2.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/flac cross/freetype cross/fribidi cross/lame cross/libass
DEPENDS += cross/libbluray cross/libvorbis cross/libvpx
DEPENDS += cross/gnutls cross/opus
DEPENDS += cross/soxr cross/x264 cross/x265

HOMEPAGE = http://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  = GPLv2

NASM_PATH=$(WORK_DIR)/../../../native/nasm/work-native/install/usr/local/bin

CONFIGURE_ARGS = --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include"
CONFIGURE_ARGS += --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib"
CONFIGURE_ARGS += --extra-libs="-lxml2 -ldl" --pkg-config=/usr/bin/pkg-config --ranlib=$(RANLIB)
CONFIGURE_ARGS += --enable-cross-compile --enable-rpath --enable-pic
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --enable-gpl
CONFIGURE_ARGS += --enable-fontconfig --enable-libass --enable-libbluray --enable-avresample
CONFIGURE_ARGS += --enable-libfreetype --enable-libfribidi --enable-libmp3lame
CONFIGURE_ARGS += --enable-libopus --enable-libsoxr
CONFIGURE_ARGS += --enable-libvorbis
CONFIGURE_ARGS += --enable-libvpx --enable-libx264 --enable-libx265 --enable-gnutls
CONFIGURE_ARGS += --disable-debug --disable-doc
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --enable-debug=1

# fdk-acc is now considered compatible with (L)GPL.
# It requires --enable-nonfree if you're also using --enable-gpl
#
# https://en.wikipedia.org/wiki/Fraunhofer_FDK_AAC
# It was classified as free by Fedora after a review by the legal department at Red Hat.
# See also: http://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AAC#FDK_License
#
DEPENDS += cross/fdk-aac
CONFIGURE_ARGS += --enable-libfdk-aac --enable-nonfree

# Enable Synology specific -hls_seek_time option and other optimizations
CONFIGURE_ARGS += --extra-cflags="-DSYNO_VIDEOSTATION -DSYNO_AUDIOSTATION -DSYNO_MEDIASERVER -DSYNO_DSM"

# Compiler workaround to enable DTS-HD MA stream decoding
CONFIGURE_ARGS += --extra-cflags="-fno-if-conversion"

include ../../mk/spksrc.cross-cc.mk

# Add AV1 codec to supported ARCH
ifeq ($(findstring $(ARCH),alpine comcerto2k monaco $(ARM8_ARCHES) $(x86_ARCHES) $(x64_ARCHES)),$(ARCH))
DEPENDS += cross/libaom
CONFIGURE_ARGS += --enable-libaom
endif

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --disable-neon --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --enable-neon --enable-thumb --disable-armv6 --disable-armv6t2 --disable-vfp --disable-armv5te --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm64 --enable-neon --enable-thumb --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += PATH=$(NASM_PATH):$$PATH

ifeq ($(findstring $(ARCH),'evansport'),$(ARCH))
DEPENDS += cross/ds.evansport cross/json-c
CONFIGURE_ARGS += --disable-x86asm
CONFIGURE_ARGS += --extra-cflags="-fasm"
CONFIGURE_ARGS += --extra-cflags="-std=c99 -pedantic"
CONFIGURE_ARGS += --extra-cflags="-pedantic"
CONFIGURE_ARGS += --extra-cflags="-Wno-deprecated-declarations"
CONFIGURE_ARGS += --extra-cflags="-DSYNO_EVANSPORT_SMD"
CONFIGURE_ARGS += --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include/intelce-utilities"
CONFIGURE_ARGS += --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include/intelce-utilities/linux_user"
CONFIGURE_ARGS += --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib/intelce-utilities"
CONFIGURE_ARGS += --extra-ldflags="-Wl,-rpath-link,$(WORK_DIR)/install$(INSTALL_PREFIX)/lib"
CONFIGURE_ARGS += --extra-ldflags="-Wl,-rpath-link,$(WORK_DIR)/install$(INSTALL_PREFIX)/lib/intelce-utilities"
CONFIGURE_ARGS += --arch=x86 --cpu=atom --enable-libh264_smd --enable-smd

else
CONFIGURE_ARGS += --arch=i386
endif
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
DEPENDS += native/nasm cross/libva cross/libva-utils cross/intel-vaapi-driver
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=x86_64 --enable-vaapi
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=ppc
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
CONFIGURE_ARGS += --disable-asm --cpu=e500v2
endif
endif
