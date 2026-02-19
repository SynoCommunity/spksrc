PKG_NAME = ffmpeg
PKG_VERS = 6.0.1
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.ffmpeg.org/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.ffmpeg.org/
COMMENT  = FFmpeg audio-only libraries for AirPlay 2 support
LICENSE  = GPLv2

# This is a minimal audio-only FFmpeg build for packages like shairport-sync
# that only need AAC decoding. It avoids the heavy video codec and hardware
# acceleration dependencies of the full ffmpeg6 package.

CONFIGURE_ARGS  = --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX)
CONFIGURE_ARGS += --pkg-config=/usr/bin/pkg-config
CONFIGURE_ARGS += --enable-cross-compile --enable-rpath --enable-pic
CONFIGURE_ARGS += --enable-shared
CONFIGURE_ARGS += --enable-gpl --enable-version3
CONFIGURE_ARGS += --disable-static
CONFIGURE_ARGS += --disable-doc
CONFIGURE_ARGS += --disable-debug

# Disable all video components - we only need audio
CONFIGURE_ARGS += --disable-programs
CONFIGURE_ARGS += --disable-ffmpeg
CONFIGURE_ARGS += --disable-ffplay
CONFIGURE_ARGS += --disable-ffprobe
CONFIGURE_ARGS += --disable-avdevice
CONFIGURE_ARGS += --disable-swscale
CONFIGURE_ARGS += --disable-postproc
CONFIGURE_ARGS += --disable-avfilter

# Disable video codecs and hardware acceleration
CONFIGURE_ARGS += --disable-hwaccels
CONFIGURE_ARGS += --disable-vaapi
CONFIGURE_ARGS += --disable-vdpau
CONFIGURE_ARGS += --disable-videotoolbox
CONFIGURE_ARGS += --disable-cuda
CONFIGURE_ARGS += --disable-cuda-llvm
CONFIGURE_ARGS += --disable-cuvid
CONFIGURE_ARGS += --disable-nvenc
CONFIGURE_ARGS += --disable-nvdec

# Disable video decoders/encoders we don't need
CONFIGURE_ARGS += --disable-encoders
CONFIGURE_ARGS += --disable-decoder=*video*
CONFIGURE_ARGS += --disable-decoder=*image*

# Enable AAC decoder (required for AirPlay 2)
CONFIGURE_ARGS += --enable-decoder=aac
CONFIGURE_ARGS += --enable-decoder=aac_latm
CONFIGURE_ARGS += --enable-decoder=alac
CONFIGURE_ARGS += --enable-decoder=pcm*
CONFIGURE_ARGS += --enable-decoder=flac

# Enable swresample for audio transcoding
CONFIGURE_ARGS += --enable-swresample

# Optimization flags
CONFIGURE_ARGS += --extra-cflags=-O3
CONFIGURE_ARGS += --extra-cflags=-Wno-deprecated-declarations

include ../../mk/spksrc.common.mk

# Minimal dependencies - no video-related packages
DEPENDS = cross/zlib

# Disable assembly for most architectures to avoid nasm dependency.
# This is acceptable for an audio-only build where performance impact is minimal.
# However, ARMv8 MUST have ASM/NEON enabled otherwise FFmpeg's init code
# references undefined NEON symbols (FFmpeg assumes NEON is always available on ARMv8).
ifneq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --disable-asm
endif

# Architecture-specific settings
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=x86_64
endif

ifeq ($(findstring $(ARCH),$(ARMv8_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm64
# Enable NEON on ARMv8 - required to compile the assembly that the init code references
CONFIGURE_ARGS += --enable-neon --enable-thumb
endif

ifeq ($(findstring $(ARCH),$(ARMv7_ARCHS) $(ARMv7L_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm
endif

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=arm
endif

ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --arch=ppc
ifeq ($(findstring $(ARCH),qoriq),$(ARCH))
CONFIGURE_ARGS += --cpu=e500v2
CONFIGURE_ARGS += --extra-libs=-latomic
else
CONFIGURE_ARGS += --cpu=e500 --disable-altivec
endif
endif

ifeq ($(findstring $(ARCH),evansport),$(ARCH))
CONFIGURE_ARGS += --arch=x86 --cpu=atom
endif

include ../../mk/spksrc.cross-cc.mk
