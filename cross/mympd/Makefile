PKG_NAME = mympd
PKG_VERS = 14.1.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jcorporation/myMPD/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = myMPD-$(PKG_VERS)

DEPENDS = cross/libmpdclient cross/openssl3 cross/pcre2 cross/libid3tag

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

HOMEPAGE = https://jcorporation.github.io/
COMMENT  = myMPD is a standalone and mobile friendly web mpd client with a tiny footprint and advanced features.
LICENSE  = GPLv3
# myMPD was originally a fork of ympd, but it has evolved into a much more comprehensive MPD client.

CMAKE_USE_TOOLCHAIN_FILE = NO
CMAKE_USE_NINJA = 0

POST_INSTALL_TARGET = mympd_post_install

include ../../mk/spksrc.cross-cmake.mk

.PHONY: mympd_post_install
mympd_post_install:
	@$(MSG) Install additional libraries...
	@install $(WORK_DIR)/$(PKG_DIR)/build/dist/libmympdclient/liblibmympdclient.so   $(STAGING_INSTALL_PREFIX)/lib/
	@install $(WORK_DIR)/$(PKG_DIR)/build/dist/mjson/libmjson.so                     $(STAGING_INSTALL_PREFIX)/lib/
	@install $(WORK_DIR)/$(PKG_DIR)/build/dist/mongoose/libmongoose.so               $(STAGING_INSTALL_PREFIX)/lib/
	@install $(WORK_DIR)/$(PKG_DIR)/build/dist/mpack/libmpack.so                     $(STAGING_INSTALL_PREFIX)/lib/
	@install $(WORK_DIR)/$(PKG_DIR)/build/dist/rax/librax.so                         $(STAGING_INSTALL_PREFIX)/lib/
	@install $(WORK_DIR)/$(PKG_DIR)/build/dist/sds/libsds.so                         $(STAGING_INSTALL_PREFIX)/lib/
