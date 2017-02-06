PKG_NAME = tvheadend
PKG_VERS = 4.0.9
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/tvheadend/tvheadend/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)

DEPENDS = cross/openssl cross/libhdhomerun

HOMEPAGE = https://www.lonelycoder.com/tvheadend/
COMMENT  = Tvheadend is a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-avahi --release --disable-hdhomerun_static --enable-hdhomerun_client
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk


.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)
