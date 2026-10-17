PKG_NAME = alsa-utils
PKG_VERS = 1.2.9
PKG_EXT = tar.bz2
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.alsa-project.org/files/pub/utils
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/alsa-lib cross/ncursesw

# Defining ADDITIONAL_CFLAGS += -DIN_NONBLOCK=O_NONBLOCK was tried and is not enough.
# glibc 2.8 <sys/inotify.h> has neither inotify_init1 nor its flags (added in 2.9):
#   alsactl/monitor.c:412: 'IN_NONBLOCK' undeclared
MIN_GLIBC_VERSION = 2.9

HOMEPAGE = https://www.alsa-project.org/
COMMENT  = Advanced Linux Sound Architecture provides audio and MIDI functionality to the Linux operating system.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-xmlto --disable-rst2man 
ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
