PKG_NAME = rtmpdump

NAME = rtmpdump
PKG_DIST_SITE = git://git.ffmpeg.org/rtmpdump
PKG_GIT_HASH = 9518486
PKG_DOWNLOAD_METHOD = git

PKG_EXT = tar.gz
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = http://rtmpdump.mplayerhq.hu/
COMMENT  = A small dumper for media content streamed over the RTMP protocol (like BBC\'s iPlayer high quality streams). Supplying an RTMP URL will result in a dumped flv file, which can be played/transcoded with standard tools.
LICENSE  = GPLv2+

CONFIGURE_TARGET = nop
COMPILE_TARGET = myCompile

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	$(RUN) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) XLDFLAGS=-L$(STAGING_INSTALL_PREFIX)/lib/ $(MAKE)

