PKG_NAME = owntone
PKG_VERS = 29.0
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/owntone/owntone-server/releases/download/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# https://github.com/owntone/owntone-server/releases/download/29.0/owntone-29.0.tar.xz
# ffmpeg7 requires c11 support
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
# archs lacking SO_REUSEPORT in sockets.h
UNSUPPORTED_ARCHS += $(ARMv7L_ARCHS) $(PPC_ARCHS) $(i686_ARCHS) comcerto2k

# build instructions:
# https://owntone.github.io/owntone-server/building/

DEPENDS  = cross/openssl3
DEPENDS += cross/libwebsockets
DEPENDS += cross/curl
DEPENDS += cross/libunistring
DEPENDS += cross/libconfuse
DEPENDS += cross/libsodium
DEPENDS += cross/mxml
DEPENDS += cross/libxml2
DEPENDS += cross/sqlite
DEPENDS += cross/libevent
DEPENDS += cross/json-c
DEPENDS += cross/libantlr3c
DEPENDS += cross/libgcrypt
DEPENDS += cross/avahi
DEPENDS += cross/libplist
DEPENDS += cross/alsa-lib
DEPENDS += cross/protobuf-c

HOMEPAGE = http://owntone.github.io/owntone-server
COMMENT = OwnTone is an open source (audio) media server.
LICENSE = GPLv2

GNU_CONFIGURE = 1

POST_INSTALL_TARGET = owntone_post_install

CONFIGURE_ARGS  = --with-libgcrypt-prefix=$(STAGING_INSTALL_PREFIX)
CONFIGURE_ARGS += --with-libgpg-error-prefix=$(STAGING_INSTALL_PREFIX)


include ../../mk/spksrc.cross-cc.mk

# install libssp of toolchain
TC_LIBSSP_FILE = libssp.so.0.0.0

.PHONY: owntone_post_install
owntone_post_install:
	@$(MSG) Install libssp from toolchain
	@$(RUN) ; install $(TC_PATH)../$(TC_LIBRARY)/$(TC_LIBSSP_FILE) $(STAGING_INSTALL_PREFIX)/lib/
	@$(RUN) ; cd $(STAGING_INSTALL_PREFIX)/lib/ && ln -sf $(TC_LIBSSP_FILE) libssp.so.0
	@$(RUN) ; cd $(STAGING_INSTALL_PREFIX)/lib/ && ln -sf $(TC_LIBSSP_FILE) libssp.so	
