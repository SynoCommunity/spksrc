PKG_NAME = ffmpeg
PKG_VERS = 2.2.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.ffmpeg.org/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/x264 cross/lame

HOMEPAGE = http://www.ffmpeg.org/
COMMENT  = FFmpeg is a complete, cross-platform solution to record, convert and stream audio and video. It includes libavcodec - the leading audio/video codec library
LICENSE  =

REQUIRED_DSM = 5.1

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH), $(ARM_ARCHES)),$(ARCH))
MYARCH = arm
endif
ifeq ($(findstring $(ARCH), $(x86_ARCHES)),$(ARCH))
MYARCH = i386
endif
ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
MYARCH = x86_64
endif
ifeq ($(findstring $(ARCH), $(PPC_ARCHES)),$(ARCH))
MYARCH = ppc
endif
ifeq ($(MYARCH),)
$(error Unsupported ARCH $(ARCH))
endif


CONFIGURE_ARGS = --disable-yasm --disable-doc --enable-gpl --enable-libx264 --enable-libmp3lame --enable-nonfree --enable-cross-compile --arch=$(MYARCH) --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX) --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include" --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib" --extra-libs=-ldl

include ../../mk/spksrc.cross-cc.mk
