PKG_NAME = tvheadend
PKG_VERS = 4.3
PKG_EXT = tar.gz
# no official release since v4.2.8 (Jan 12, 2019)
# git hash from Aug 7th 2026
PKG_GIT_HASH = ddb984f4c17f4a26fd34f3e1b24e3323f9641b75
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tvheadend/tvheadend/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

HOMEPAGE = https://tvheadend.org/
COMMENT  = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
LICENSE  = GPLv3

# Its own sources redefine typedefs, which only C11 allows -- gcc from 4.6, where 4.3.7
# stops at "redefinition of typedef 'streaming_start_t'". Nothing above that: the ffmpeg
# floor is ffmpeg's, and the meta below picks the version an arch can build.
MIN_GCC_VERSION = 4.6

include ../../mk/spksrc.common.mk

OPTIONAL_DEPENDS  = cross/ffmpeg4
OPTIONAL_DEPENDS += cross/ffmpeg8
OPTIONAL_DEPENDS += cross/intel-libvpl
OPTIONAL_DEPENDS += cross/intel-mediasdk
OPTIONAL_DEPENDS += cross/libva
OPTIONAL_DEPENDS += cross/libvpx
OPTIONAL_DEPENDS += cross/x264
OPTIONAL_DEPENDS += cross/x265

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = tvheadend_pre_configure
POST_INSTALL_TARGET = tvheadend_post_install

# Options that answer to no dependency of their own
CONFIGURE_ARGS  = --python=/usr/bin/python3
CONFIGURE_ARGS += --enable-imagecache --enable-bundle --enable-trace --release
CONFIGURE_ARGS += --enable-imagecache_audit
CONFIGURE_ARGS += --disable-bintray_cache --disable-avahi

# WARNING: pngquant fails when built after cross/zlib (i.e. cross/libpng), so it stays the
# first dependency named -- ahead of the alphabetical order everything below follows.
DEPENDS  = cross/pngquant
CONFIGURE_ARGS += --enable-pngquant

# Dependencies with no option of their own: found by probe, or pulled in by another
DEPENDS += cross/fontconfig
DEPENDS += cross/gnutls
DEPENDS += cross/libiconv
DEPENDS += cross/openssl3
DEPENDS += cross/pcre2
DEPENDS += cross/uriparser

# Each remaining dependency beside what it answers for. Declared outright rather than
# behind "no FFMPEG_PACKAGE work dir": a meta has already built the media libraries and
# symlinks its status cookies here, so each is a no-op, not a second build.
DEPENDS += cross/curl
# curl build needs additional configuration for gnutls and libssh2
export BUILD_CURL_WITH="gnutls libssh2 zstd"

DEPENDS += cross/dbus
CONFIGURE_ARGS += --enable-dbus_1
# dbus splits its headers between include/ and lib/dbus-1.0/include/
#    - include/dbus-1.0/ (public) must precede
#    - lib/dbus-1.0/include/ (arch-specific dbus-arch-deps.h)
ADDITIONAL_CFLAGS += -I$(or $(VIDEODRV_STAGING_INSTALL_PREFIX),$(STAGING_INSTALL_PREFIX))/include/dbus-1.0
ADDITIONAL_CFLAGS += -I$(or $(VIDEODRV_STAGING_INSTALL_PREFIX),$(STAGING_INSTALL_PREFIX))/lib/dbus-1.0/include

DEPENDS += cross/fdk-aac
CONFIGURE_ARGS += --disable-libfdkaac_static --enable-libfdkaac

# ffmpeg8 needs gcc >= 4.9, ffmpeg4 declares none
# Keep in step with spk/tvheadend, which picks its FFMPEG_PACKAGE the same way.
ifeq ($(call version_lt,$(TC_GCC),4.9),1)
DEPENDS += cross/ffmpeg4
else
DEPENDS += cross/ffmpeg8
endif
CONFIGURE_ARGS += --disable-ffmpeg_static --enable-libav

DEPENDS += cross/libdvbcsa cross/dvb-apps
CONFIGURE_ARGS += --enable-dvbcsa

DEPENDS += cross/libhdhomerun
CONFIGURE_ARGS += --disable-hdhomerun_static --enable-hdhomerun_client

DEPENDS += cross/libtheora
CONFIGURE_ARGS += --disable-libtheora_static --enable-libtheora

ifneq ($(VIDEODRV_ON),)
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
DEPENDS += cross/libva
CONFIGURE_ARGS += --enable-vaapi

# qsv wants libmfx >= 1.28 from intel-mediasdk or oneVPL >= 2.0
DEPENDS += cross/intel-mediasdk
ifeq ($(call version_gt, $(TC_GCC), 5),1)
DEPENDS += cross/intel-libvpl
CONFIGURE_ARGS += --enable-qsv
endif  # TC_GCC > 5
endif  # x64
endif  # VIDEODRV_ON

DEPENDS += cross/libvorbis
CONFIGURE_ARGS += --disable-libvorbis_static --enable-libvorbis

DEPENDS += cross/libvpx
CONFIGURE_ARGS += --disable-libvpx_static --enable-libvpx

DEPENDS += cross/opus
CONFIGURE_ARGS += --disable-libopus_static --enable-libopus

DEPENDS += cross/x264
CONFIGURE_ARGS += --disable-libx264_static --enable-libx264

# x265 needs gcc >= 4.8. Disabled explicitly below that: it defaults to enabled AND
# static upstream, so omitting the pair keeps it and asks for a bundled build.
ifeq ($(call version_ge,$(TC_GCC),4.8),1)
DEPENDS += cross/x265
CONFIGURE_ARGS += --disable-libx265_static --enable-libx265
else
CONFIGURE_ARGS += --disable-libx265
endif

# Enable building of new UI
BUILD_DEPENDS = native/nodejs_22
CONFIGURE_ARGS += --enable-vue_build
# Build environment - use native Node.js from spksrc
ENV += PATH=$(WORK_DIR)/../../../native/nodejs_22/work-native/node/bin:$$PATH

ifeq ($(call version_lt, ${TC_GCC}, 5.0),1)
CONFIGURE_ARGS += --nowerror
ADDITIONAL_CFLAGS += -std=gnu99
endif

include ../../mk/spksrc.cross-cc.mk

.PHONY: tvheadend_pre_configure
tvheadend_pre_configure:
	# Fix so mkbundle finds the pngquant binary
	@$(RUN) sed -i.bak "s|^pngquant_bin = '/usr|pngquant_bin = '$(STAGING_INSTALL_PREFIX)|g" support/mkbundle

.PHONY: tvheadend_post_install
tvheadend_post_install:
	# Enforce python3
	@$(RUN) sed -i 's|env python$$|env python3|g' $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/tv_meta_tmdb.py
	@$(RUN) sed -i 's|env python$$|env python3|g' $(INSTALL_DIR)/$(INSTALL_PREFIX)/bin/tv_meta_tvdb.py
