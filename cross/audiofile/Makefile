PKG_NAME = audiofile
PKG_VERS = 0.3.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://audiofile.68k.org
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/alsa-lib

HOMEPAGE = https://www.68k.org/~michael/audiofile/
COMMENT  = Handle reading and writing audio files in many common formats.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-examples --disable-docs
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
