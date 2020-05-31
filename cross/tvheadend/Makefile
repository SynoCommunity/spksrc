PKG_NAME = tvheadend
PKG_VERS = 4.3
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = e59b92e9f317b758e69fe5e0d0037d44d2d0a33a
PKG_DIST_SITE = https://github.com/tvheadend/tvheadend.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/openssl cross/uriparser cross/pcre2 cross/libiconv native/python
DEPENDS += cross/libhdhomerun cross/libdvbcsa cross/dvb-apps cross/libtheora cross/pngquant

HOMEPAGE = https://tvheadend.org/
COMMENT  = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
LICENSE  = GPL v3

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-imagecache --enable-bundle --enable-trace --release
CONFIGURE_ARGS += --disable-bintray_cache --disable-avahi
CONFIGURE_ARGS += --enable-dvbcsa --enable-pngquant
CONFIGURE_ARGS += --disable-hdhomerun_static --enable-hdhomerun_client
CONFIGURE_ARGS += --disable-ffmpeg_static --enable-libav
CONFIGURE_ARGS += --disable-libopus_static --disable-libtheora_static --disable-libvorbis_static
CONFIGURE_ARGS += --disable-libvpx_static --disable-libx264_static --disable-libx265_static

# fdk-acc is now considered compatible with (L)GPL.
# It requires --enable-nonfree if you're also using --enable-gpl
#
# https://en.wikipedia.org/wiki/Fraunhofer_FDK_AAC
# It was classified as free by Fedora after a review by the legal department at Red Hat.
# See also: http://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AAC#FDK_License
#
DEPENDS += cross/fdk-aac
CONFIGURE_ARGS += --disable-libfdkaac_static --enable-libfdkaac

ifeq ($(wildcard $(FFMPEG_DIR)),)
DEPENDS += cross/ffmpeg
endif

include ../../mk/spksrc.cross-cc.mk

ifeq ($(findstring $(ARCH),$(ARM5_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --nowerror
endif

ifeq ($(findstring $(ARCH), $(x64_ARCHES)),$(ARCH))
CONFIGURE_ARGS += --enable-vaapi
ifeq ($(wildcard $(FFMPEG_DIR)),)
DEPENDS += cross/libva
endif
endif
