PKG_NAME = asterisk
PKG_VERS = 1.8.14.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.asterisk.org/pub/telephony/asterisk/releases
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/libxml2 cross/sqlite cross/openssl cross/curl cross/libogg cross/libvorbis
DEPENDS += cross/alsa-lib cross/portaudio cross/neon cross/iksemel cross/ncurses

HOMEPAGE = http://www.asterisk.org/
COMMENT  = Asterisk is an open source framework for building communications applications. Asterisk turns an ordinary computer into a communications server. Asterisk powers IP PBX systems, VoIP gateways, conference servers and more. It is used by small businesses, large businesses, call centers, carriers and governments worldwide. Asterisk is free and open source. Asterisk is sponsored by Digium
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-xmldoc --sbindir=$(STAGING_INSTALL_PREFIX)/bin

include ../../mk/spksrc.cross-cc.mk

