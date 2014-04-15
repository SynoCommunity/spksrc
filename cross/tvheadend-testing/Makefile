PKG_NAME = tvheadend-testing
PKG_VERS = 3.9.512
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = b917ffa475
PKG_DIST_NAME = tvheadend.git
PKG_DIST_SITE = https://github.com/tvheadend
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git*

#PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
#PKG_DIST_SITE = https://github.com/tvheadend/tvheadend/archive
#PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl

HOMEPAGE = https://www.lonelycoder.com/tvheadend/
COMMENT  = Tvheadend is a TV streaming server for Linux supporting DVB-S, DVB-S2, DVB-C, DVB-T, ATSC, IPTV, and Analog video (V4L) as input sources
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-avahi --release
INSTALL_TARGET = myInstall

PRE_PATCH_TARGET = pre_patch_target_tvheadend-testing
POST_COMPILE_TARGET = post_compile_target_tvheadend-testing

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	$(RUN) make install DESTDIR=$(INSTALL_DIR)

pre_patch_target_tvheadend-testing:
	sed -i -e 's|!!!|$(PKG_VERS)|' $(PWD)/patches/version.patch

post_compile_target_tvheadend-testing:
	sed -i -e 's|$(PKG_VERS)|!!!|' $(PWD)/patches/version.patch
