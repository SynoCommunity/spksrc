PKG_NAME = librtmp
REAL_NAME = distrotech-rtmpdump
PKG_VERS = 2.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(REAL_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Distrotech/rtmpdump/archive
PKG_DIR = rtmpdump-$(REAL_NAME)-$(PKG_VERS)/librtmp

DEPENDS = cross/zlib cross/openssl

HOMEPAGE = https://rtmpdump.mplayerhq.hu/
COMMENT  = rtmpdump is a toolkit for RTMP streams. All forms of RTMP are supported, including rtmp://, rtmpt://, rtmpe://, rtmpte://, and rtmps://. 
LICENSE  = GPLv2

CONFIGURE_TARGET = nop

include ../../mk/spksrc.cross-cc.mk

ENV += XCFLAGS="$(CFLAGS)"
ENV += XLDFLAGS="$(LDFLAGS)"
