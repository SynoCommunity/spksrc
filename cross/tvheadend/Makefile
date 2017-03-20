PKG_NAME = tvheadend
PKG_VERS = master
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tvheadend/tvheadend/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS = cross/openssl cross/uriparser cross/libdvbcsa cross/dvb-apps cross/libhdhomerun cross/ffmpeg-3.2.4

HOMEPAGE = https://www.lonelycoder.com/tvheadend/
COMMENT  = Tvheadend is a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources
LICENSE  = GPLv3

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-imagecache --disable-avahi --enable-dvbcsa --enable-bundle --release
CONFIGURE_ARGS += --disable-hdhomerun_static --enable-hdhomerun_client
CONFIGURE_ARGS += --disable-ffmpeg_static --enable-libav

INSTALL_TARGET = myInstall
POST_PATCH_TARGET = post_patch_target_tvheadend

include ../../mk/spksrc.cross-cc.mk


.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

post_patch_target_tvheadend:
	@if [ "$(ARCH)" = "ppc853x" ] || [ "$(ARCH)" = "qoriq" ]; then \
		cat $(PWD)/patches/ppc/iptos.patch | ($(RUN) patch -p0) ;\
		cat $(PWD)/patches/ppc/isoc9x.patch | ($(RUN) patch -p0) ;\
	fi;
