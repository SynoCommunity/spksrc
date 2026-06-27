PKG_NAME = mympd
PKG_VERS = 24.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/jcorporation/myMPD/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = myMPD-$(PKG_VERS)

DEPENDS = cross/flac cross/libmpdclient cross/openssl3 cross/pcre2 cross/libid3tag cross/utf8proc cross/lua
BUILD_DEPENDS = native/lua
LUA_NATIVE_PATH = $(abspath $(PWD)/../../native/lua/work-native/install/bin)
ENV += PATH=$(LUA_NATIVE_PATH):$$PATH

REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

HOMEPAGE = https://jcorporation.github.io/
COMMENT  = myMPD is a standalone and mobile friendly web mpd client with a tiny footprint and advanced features.
LICENSE  = GPLv3

CMAKE_USE_NINJA = 0
CMAKE_ARGS += -DLUA_INCLUDE_DIR:PATH=$(INSTALL_DIR)$(INSTALL_PREFIX)/include
CMAKE_ARGS += -DLUA_LIBRARY:FILEPATH=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib/liblua.so
CMAKE_ARGS += -DLUA_MATH_LIBRARY:STRING=m
CMAKE_ARGS += -DMYMPD_ENABLE_MYGPIOD=OFF
CMAKE_ARGS += -DMYMPD_DOC=OFF
CMAKE_ARGS += -DMYMPD_MANPAGES=OFF
CMAKE_ARGS += -DMYMPD_STARTUP_SCRIPT=OFF
CMAKE_ARGS += -DCMAKE_POSITION_INDEPENDENT_CODE=ON
CMAKE_ARGS += -DMATH_LIB:STRING=m

POST_INSTALL_TARGET = mympd_post_install

include ../../mk/spksrc.cross-cmake.mk

.PHONY: mympd_post_install
mympd_post_install:
	@$(MSG) Install additional libraries...
	@install $(WORK_DIR)/$(PKG_DIR)/build/dist/mongoose/libmongoose.so $(STAGING_INSTALL_PREFIX)/lib/
	@install $(WORK_DIR)/$(PKG_DIR)/build/dist/mpack/libmpack.so $(STAGING_INSTALL_PREFIX)/lib/
	@install $(WORK_DIR)/$(PKG_DIR)/build/dist/rax/librax.so $(STAGING_INSTALL_PREFIX)/lib/
	@install $(WORK_DIR)/$(PKG_DIR)/build/dist/sds/libsds.so $(STAGING_INSTALL_PREFIX)/lib/
