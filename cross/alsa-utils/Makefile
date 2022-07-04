PKG_NAME = alsa-utils
PKG_VERS = 1.0.29
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.alsa-project.org/files/pub/utils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/alsa-lib cross/ncursesw

HOMEPAGE = https://www.alsa-project.org/
COMMENT  = Advanced Linux Sound Architecture provides audio and MIDI functionality to the Linux operating system.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
