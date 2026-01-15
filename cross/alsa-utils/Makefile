PKG_NAME = alsa-utils
PKG_VERS = 1.2.9
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.alsa-project.org/files/pub/utils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/alsa-lib cross/ncursesw

# incomplete implementation of inotify
# monitor.c:(.text+0x604): undefined reference to `inotify_init1'
# with additional definition "ADDITIONAL_CFLAGS += -DIN_NONBLOCK=O_NONBLOCK"
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.alsa-project.org/
COMMENT  = Advanced Linux Sound Architecture provides audio and MIDI functionality to the Linux operating system.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-xmlto --disable-rst2man 
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
