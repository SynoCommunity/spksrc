PKG_NAME = libvorbis
PKG_VERS = 1.3.7
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.osuosl.org/pub/xiph/releases/vorbis
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libogg

HOMEPAGE = https://xiph.org/vorbis
COMMENT  = Ogg Vorbis is a fully open, non-proprietary, patent-and-royalty-free, general-purpose compressed audio format for mid to high quality (8kHz-48.0kHz, 16+ bit, polyphonic) audio and music at fixed and variable bitrates from 16 to 128 kbps/channel.
LICENSE  = BSD

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static
ADDITIONAL_CFLAGS = -Os

include ../../mk/spksrc.cross-cc.mk
