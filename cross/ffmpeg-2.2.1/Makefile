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

# Define SYNCTHING_ARCH as per SyncThing standards
ifeq ($(findstring $(ARCH),88f5281 88f6281),$(ARCH))
MYARCH = armv5
endif
ifeq ($(findstring $(ARCH),armada370 armadaxp armada375),$(ARCH))
MYARCH = armv7
endif
ifeq ($(findstring $(ARCH),evansport),$(ARCH))
MYARCH = 386
endif
ifeq ($(findstring $(ARCH),x86 cedarview bromolow x64),$(ARCH))
MYARCH = x86_64
endif
ifeq ($(MYARCH),)
$(error Unsupported ARCH $(ARCH))
endif


CONFIGURE_ARGS = --disable-yasm --disable-doc --enable-gpl --enable-libx264 --enable-libmp3lame --enable-nonfree --enable-cross-compile --arch=$(MYARCH) --target-os=linux --cross-prefix=$(TC_PATH)$(TC_PREFIX) --prefix=$(INSTALL_PREFIX) --extra-cflags="-I$(WORK_DIR)/install$(INSTALL_PREFIX)/include" --extra-ldflags="-L$(WORK_DIR)/install$(INSTALL_PREFIX)/lib" --extra-libs=-ldl

include ../../mk/spksrc.cross-cc.mk
