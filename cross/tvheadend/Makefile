PKG_NAME = tvheadend
PKG_VERS = 4.2.3
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tvheadend/tvheadend/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS = cross/openssl cross/libhdhomerun cross/uriparser cross/libdvbcsa
DEPENDS += cross/dvb-apps cross/pngquant cross/ffmpeg-3.3.2

HOMEPAGE = https://www.lonelycoder.com/tvheadend/
COMMENT  = Tvheadend is a TV streaming server and recorder for Linux, FreeBSD and Android supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, ISDB-T, IPTV, SAT IP and HDHomeRun as input sources. Tvheadend offers HTTP, HTSP and SAT IP streaming.
LICENSE  = GPL v3

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --enable-imagecache --disable-avahi --enable-dvbcsa --enable-pngquant --enable-bundle --release
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
		cat $(PWD)/patches/ppc/isoc9x.patch | ($(RUN) patch -p0) ;\
	fi;
