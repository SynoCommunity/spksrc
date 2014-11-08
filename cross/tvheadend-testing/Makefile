PKG_NAME = tvheadend-testing
PKG_VERS = 3.9.1987
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = c053acd84e
PKG_DIST_NAME = tvheadend.git
PKG_DIST_SITE = https://github.com/tvheadend
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git*

#DEPENDS = cross/openssl cross/curl cross/uriparser cross/ffmpeg-1.2.7 cross/libdvbcsa cross/comskip
#DEPENDS = cross/openssl cross/curl cross/uriparser cross/ffmpeg-1.2.7 cross/libdvbcsa
DEPENDS = cross/openssl cross/curl cross/uriparser cross/ffmpeg-2.4.2 cross/libdvbcsa

HOMEPAGE = https://www.lonelycoder.com/tvheadend/
COMMENT  = Tvheadend is a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-bundle --enable-imagecache --enable-uriparser --enable-libav --enable-dvbcsa --disable-avahi --release
INSTALL_TARGET = myInstall

PRE_PATCH_TARGET = pre_patch_target_tvheadend-testing

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

pre_patch_target_tvheadend-testing:
	sed -i -e '8s|^.*$$|+  VER="$(PKG_VERS)"|' $(PWD)/patches/version.patch
