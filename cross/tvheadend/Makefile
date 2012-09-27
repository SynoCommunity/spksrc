PKG_NAME = tvheadend
PKG_VERS = 3.3
PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_NAME = $(PKG_VERS)
PKG_DIST_SITE = https://github.com/tvheadend/tvheadend/tarball
PKG_DIR = tvheadend-$(PKG_NAME)-*

DEPENDS = cross/openssl

HOMEPAGE = https://www.lonelycoder.com/tvheadend/
COMMENT  = Tvheadend is a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-avahi --release
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk


.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)
