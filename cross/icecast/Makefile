PKG_NAME = icecast
PKG_VERS = 2.4.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/xiph/releases/icecast
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libxml2 cross/openssl cross/curl cross/libvorbis cross/libxslt cross/speex cross/libtheora cross/ezstream

HOMEPAGE = https://www.icecast.org
COMMENT  = Icecast is a streaming media server which currently supports Ogg (Vorbis and Theora), Opus, WebM and MP3 audio streams.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --with-xslt-config=$(STAGING_INSTALL_PREFIX)/bin/xslt-config

include ../../mk/spksrc.cross-cc.mk
