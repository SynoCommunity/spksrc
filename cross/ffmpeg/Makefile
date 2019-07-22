PKG_NAME = ffmpeg
PKG_VERS = 4.1
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

# fdk-acc is not compatible with (L)GPL.
# It can be enabled for personal use, but not for freely distributed packages.
# Uncomment the following lines if you want to enable it.
# DEPENDS += cross/fdk-aac
# CONFIGURE_ARGS += --enable-libfdk-aac --enable-nonfree

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --disable-neon --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARM7_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm --enable-neon --disable-armv6 --disable-armv6t2 --disable-vfp --disable-armv5te --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(ARM8_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --arch=arm64 --enable-neon --disable-yasm --disable-asm
endif

ifeq ($(findstring $(ARCH),$(x86_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=i386 --enable-thumb
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHES)),$(ARCH))
DEPENDS += native/nasm cross/libva cross/libva-utils cross/intel-vaapi-driver
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=x86_64 --enable-thumb --enable-vaapi
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHES)),$(ARCH))
DEPENDS += native/nasm
ENV += PATH=$(NASM_PATH):$$PATH
CONFIGURE_ARGS += --arch=ppc
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
CONFIGURE_ARGS += --disable-asm --cpu=e500v2
endif
endif
