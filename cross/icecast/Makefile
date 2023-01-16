PKG_NAME = icecast
PKG_VERS = 2.4.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/xiph/releases/icecast
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/libxslt cross/openssl cross/curl cross/libvorbis cross/speex cross/libtheora cross/ezstream

HOMEPAGE = https://www.icecast.org
COMMENT  = Icecast is a streaming media server which currently supports Ogg (Vorbis and Theora), Opus, WebM and MP3 audio streams.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
POST_INSTALL_TARGET = icecast_extra_install

CONFIGURE_ARGS = --with-xslt-config=$(STAGING_INSTALL_PREFIX)/bin/xslt-config
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk

.PHONY: icecast_extra_install
icecast_extra_install:
	@$(RUN) cp win32/icecast.ico $(STAGING_INSTALL_PREFIX)/share/icecast/web/favicon.ico
