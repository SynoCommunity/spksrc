PKG_NAME = tvheadend
PKG_VERS = 4.3
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = 221c29b40b1e53ae09a69d9458442dd4fea665f5
PKG_DIST_SITE = https://github.com/tvheadend/tvheadend.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/openssl cross/libhdhomerun cross/uriparser cross/libdvbcsa cross/pcre2 cross/dvb-apps cross/libiconv

HOMEPAGE = https://tvheadend.org/
COMMENT  = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
LICENSE  = GPL v3

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-imagecache --disable-avahi --enable-dvbcsa --enable-bundle --release
CONFIGURE_ARGS += --disable-hdhomerun_static --enable-hdhomerun_client
CONFIGURE_ARGS += --disable-ffmpeg_static --enable-libav
CONFIGURE_ARGS += --disable-libfdkaac_static --disable-libopus_static --disable-libtheora --disable-libtheora_static
CONFIGURE_ARGS += --disable-libvorbis_static --disable-libvpx_static --disable-libx264_static --disable-libx265_static

ifeq ($(wildcard $(FFMPEG_DIR)),)
DEPENDS += cross/ffmpeg
endif

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --nowerror
endif
