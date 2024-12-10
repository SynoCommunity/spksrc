PKG_NAME = tvheadend
PKG_VERS = 4.3
PKG_EXT = tar.gz
# no official release since v4.2.8 (Jan 12, 2019)
# git hash from Sept 28th 2024
PKG_GIT_HASH = 28de5c092c657ffbbffa422c2ca3c07ba513c567
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tvheadend/tvheadend/archive
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

HOMEPAGE = https://tvheadend.org/
COMMENT  = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
LICENSE  = GPLv3

# PPC archs except qoriq are not supported
# https://tvheadend.org/issues/5060
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# ffmpeg7 requires c11 support
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

OPTIONAL_DEPENDS += cross/ffmpeg7
OPTIONAL_DEPENDS += cross/fdk-aac
OPTIONAL_DEPENDS += cross/fontconfig
OPTIONAL_DEPENDS += cross/opus
OPTIONAL_DEPENDS += cross/pcre2
OPTIONAL_DEPENDS += cross/libtheora
OPTIONAL_DEPENDS += cross/libvorbis
OPTIONAL_DEPENDS += cross/libvpx
OPTIONAL_DEPENDS += cross/x264
OPTIONAL_DEPENDS += cross/x265

# WARNING: pngquant will fail when built after cross/zlib (i.e. cross/libpng)
# with prebuilt ffmpeg this is not a problem
# without prebuilt ffmpeg the "DEPENDS += cross/ffmpeg*" must be defined below
DEPENDS  = cross/pngquant

DEPENDS += cross/openssl3 cross/gnutls
DEPENDS += cross/uriparser cross/libiconv
DEPENDS += cross/libdvbcsa cross/dvb-apps
DEPENDS += cross/libhdhomerun

DEPENDS += cross/curl
# curl build needs additional configuration for gnutls and libssh2
export BUILD_CURL_WITH="gnutls libssh2 zstd"

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = tvheadend_pre_configure
POST_INSTALL_TARGET = tvheadend_post_install

CONFIGURE_ARGS  = --python=/usr/bin/python3
CONFIGURE_ARGS += --enable-imagecache --enable-bundle --enable-trace --release
CONFIGURE_ARGS += --disable-bintray_cache --disable-avahi
CONFIGURE_ARGS += --enable-dvbcsa --enable-pngquant
CONFIGURE_ARGS += --disable-hdhomerun_static --enable-hdhomerun_client

# Enable media libraries incoming from FFMPEG
CONFIGURE_ARGS += --disable-libfdkaac_static --enable-libfdkaac
CONFIGURE_ARGS += --disable-libopus_static --enable-libopus
CONFIGURE_ARGS += --disable-libtheora_static --enable-libtheora
CONFIGURE_ARGS += --disable-libvorbis_static --enable-libvorbis
CONFIGURE_ARGS += --disable-libvpx_static --enable-libvpx
CONFIGURE_ARGS += --disable-libx264_static --enable-libx264
CONFIGURE_ARGS += --disable-libx265_static --enable-libx265
CONFIGURE_ARGS += --disable-ffmpeg_static --enable-libav

include ../../mk/spksrc.common.mk

ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-vaapi
endif

# Use media and other libraries through FFMPEG package shared libraries
ifneq ($(wildcard $(FFMPEG_PACKAGE_ROOT)),)
MEDIA_LIBS  = fdk-aac.pc
MEDIA_LIBS += fontconfig.pc
MEDIA_LIBS += ogg.pc
MEDIA_LIBS += opus.pc
MEDIA_LIBS += libpcre2-8.pc
MEDIA_LIBS += libpcre2-32.pc
MEDIA_LIBS += libpcre2-posix.pc
MEDIA_LIBS += theoradec.pc
MEDIA_LIBS += theoraenc.pc
MEDIA_LIBS += theora.pc
MEDIA_LIBS += vorbisenc.pc
MEDIA_LIBS += vorbisfile.pc
MEDIA_LIBS += vorbis.pc
MEDIA_LIBS += vpx.pc
MEDIA_LIBS += x264.pc
MEDIA_LIBS += x265.pc

else
DEPENDS += cross/ffmpeg7
DEPENDS += cross/fdk-aac
DEPENDS += cross/fontconfig
DEPENDS += cross/opus
DEPENDS += cross/pcre2
DEPENDS += cross/libtheora
DEPENDS += cross/libvorbis
DEPENDS += cross/libvpx
DEPENDS += cross/x264
DEPENDS += cross/x265
ifeq ($(findstring $(ARCH),$(x64_ARCHS)),$(ARCH))
DEPENDS += cross/libva
endif
endif

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
