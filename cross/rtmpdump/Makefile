PKG_NAME = rtmpdump
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_GIT_HASH = fa8646daeb19dfd12c181f7d19de708d623704c0
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_SITE = https://git.ffmpeg.org/rtmpdump
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS = cross/openssl

HOMEPAGE = http://rtmpdump.mplayerhq.hu/
COMMENT  = rtmpdump is a toolkit for RTMP streams. All forms of RTMP are supported, including rtmp://, rtmpt://, rtmpe://, rtmpte://, and rtmps://.
LICENSE  = GPLv2

CONFIGURE_TARGET = Nope
COMPILE_TARGET = myCompile

include ../../mk/spksrc.cross-cc.mk

myCompile:
	$(RUN) $(MAKE) SYS=posix prefix=$(INSTALL_PREFIX) CROSS_COMPILE=$(TC_PATH)$(TC_PREFIX) INC=-I$(INSTALL_DIR)$(INSTALL_PREFIX)/include LDFLAGS=" $(LDFLAGS)"

