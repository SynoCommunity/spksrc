PKG_NAME = tvheadend
PKG_VERS = 4.3
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 9ed76c0a176b055a57b6e8bd2e0b6e29409269a9
PKG_DIST_SITE = https://github.com/tvheadend/tvheadend.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/openssl cross/uriparser cross/pcre2 cross/libiconv
DEPENDS += cross/libhdhomerun cross/libdvbcsa cross/dvb-apps cross/pngquant

HOMEPAGE = https://tvheadend.org/
COMMENT  = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
LICENSE  = GPL v3

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = tvheadend_pre_configure

CONFIGURE_ARGS = --enable-imagecache --enable-bundle --enable-trace --release
CONFIGURE_ARGS += --disable-bintray_cache --disable-avahi
CONFIGURE_ARGS += --enable-dvbcsa --enable-pngquant
CONFIGURE_ARGS += --disable-hdhomerun_static --enable-hdhomerun_client

# Enable all libraries incoming from FFMPEG
CONFIGURE_ARGS += --disable-libfdkaac_static --enable-libfdkaac
CONFIGURE_ARGS += --disable-libopus_static --enable-libopus
CONFIGURE_ARGS += --disable-libtheora_static --enable-libtheora
CONFIGURE_ARGS += --disable-libvorbis_static --enable-libvorbis
CONFIGURE_ARGS += --disable-libvpx_static --enable-libvpx
CONFIGURE_ARGS += --disable-libx264_static --enable-libx264
CONFIGURE_ARGS += --disable-libx265_static --enable-libx265
ifeq ($(wildcard $(FFMPEG_DIR)),)
DEPENDS += cross/fdk-aac cross/opus cross/libtheora cross/libvorbis cross/libvpx cross/x264 cross/x265
endif

CONFIGURE_ARGS += --disable-ffmpeg_static --enable-libav
ifeq ($(wildcard $(FFMPEG_DIR)),)
DEPENDS += cross/ffmpeg
endif

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARMv5_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --nowerror
endif

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-vaapi
ifeq ($(wildcard $(FFMPEG_DIR)),)
DEPENDS += cross/libva
endif
endif

.PHONY: tvheadend_pre_configure
tvheadend_pre_configure:
	# Fix so mkbundle finds the pngquant binary
	@$(RUN) sed -i.bak "s|^pngquant_bin = '/usr|pngquant_bin = '$(STAGING_INSTALL_PREFIX)|g" support/mkbundle
