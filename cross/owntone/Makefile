PKG_NAME = owntone
PKG_VERS = 28.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/owntone/owntone-server/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

OPTIONAL_DEPENDS = cross/ffmpeg

DEPENDS = cross/libunistring cross/zlib cross/libconfuse cross/curl
DEPENDS += cross/mxml cross/sqlite cross/libevent cross/json-c
DEPENDS += cross/libantlr3c cross/libgcrypt
DEPENDS += cross/avahi
DEPENDS += cross/libplist
DEPENDS += cross/libwebsockets
DEPENDS += cross/libsodium
DEPENDS += cross/alsa-lib

ifeq ($(wildcard $(FFMPEG_DIR)),)
DEPENDS += cross/ffmpeg
endif

HOMEPAGE = http://owntone.github.io/owntone-server
COMMENT  = OwnTone is forked-daapd's new name. Linux/FreeBSD DAAP (iTunes) and MPD media server with support for AirPlay devices (multiroom), Apple Remote (and compatibles), Chromecast, Spotify and internet radio. 
LICENSE  = GPLv2

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -std=c99

POST_INSTALL_TARGET = owntone_post_install

include ../../mk/spksrc.cross-cc.mk

# use libssp of toolchain
TC_LIPRARY_PATH = $(WORK_DIR)/../../../toolchain/syno-$(ARCH)-$(TC_VERS)/work/$(TC_TARGET)/$(TC_LIBRARY)

.PHONY: owntone_post_install
owntone_post_install:
	@$(RUN) install $(TC_LIPRARY_PATH)/libssp.so.0.0.0 $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/
	@$(RUN) ; cd $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/ && ln -sf libssp.so.0.0.0 libssp.so.0
	@$(RUN) ; cd $(INSTALL_DIR)/$(INSTALL_PREFIX)/lib/ && ln -sf libssp.so.0.0.0 libssp.so	
