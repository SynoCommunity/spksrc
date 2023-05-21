PKG_NAME = owntone
PKG_VERS = 28.1
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/owntone/owntone-server/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

OPTIONAL_DEPENDS = cross/ffmpeg4

DEPENDS = cross/libunistring cross/zlib cross/libconfuse cross/curl
DEPENDS += cross/mxml cross/sqlite cross/libevent cross/json-c
DEPENDS += cross/libantlr3c cross/libgcrypt
DEPENDS += cross/avahi
DEPENDS += cross/libplist
DEPENDS += cross/libwebsockets
DEPENDS += cross/libsodium
DEPENDS += cross/alsa-lib

ifeq ($(wildcard $(FFMPEG_DIR)),)
DEPENDS += cross/ffmpeg4
endif

HOMEPAGE = http://owntone.github.io/owntone-server
COMMENT  = OwnTone is forked-daapd's new name. Linux/FreeBSD DAAP (iTunes) and MPD media server with support for AirPlay devices (multiroom), Apple Remote (and compatibles), Chromecast, Spotify and internet radio. 
LICENSE  = GPLv2

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -std=c99

include ../../mk/spksrc.archs.mk
ifneq ($(findstring $(ARCH),$(ARMv5_ARCHS) $(PPC_ARCHS)),$(ARCH))
POST_INSTALL_TARGET = owntone_post_install
else
PLIST_TRANSFORM = sed -e '/\/libssp\.so/d' 
endif

include ../../mk/spksrc.cross-cc.mk

# install libssp of toolchain
TC_LIBSSP_FILE = libssp.so.0.0.0

.PHONY: owntone_post_install
owntone_post_install:
	@$(MSG) Install libssp from toolchain
	@$(RUN) ; install $(TC_PATH)../$(TC_LIBRARY)/$(TC_LIBSSP_FILE) $(STAGING_INSTALL_PREFIX)/lib/
	@$(RUN) ; cd $(STAGING_INSTALL_PREFIX)/lib/ && ln -sf $(TC_LIBSSP_FILE) libssp.so.0
	@$(RUN) ; cd $(STAGING_INSTALL_PREFIX)/lib/ && ln -sf $(TC_LIBSSP_FILE) libssp.so	
