PKG_NAME = rtmpdump
PKG_VERS = 2.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://rtmpdump.mplayerhq.hu/download
PKG_DIR = $(PKG_NAME)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = http://rtmpdump.mplayerhq.hu/
COMMENT  = A small dumper for media content streamed over the RTMP protocol (like BBC\'s iPlayer high quality streams). Supplying an RTMP URL will result in a dumped flv file, which can be played/transcoded with standard tools.
LICENSE  = GPLv2+

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) XLDFLAGS=-L$(STAGING_INSTALL_PREFIX)/lib/ LDFLAGS=" $(LDFLAGS)" $(MAKE)

