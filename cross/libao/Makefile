PKG_NAME_SHORT = ao
PKG_NAME = lib$(PKG_NAME_SHORT)
PKG_VERS = 1.2.0
PKG_EXT = tar.gz
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.xiph.org/releases/$(PKG_NAME_SHORT)

DEPENDS = cross/alsa-lib cross/pulseaudio

HOMEPAGE = http://www.xiph.org/ao/
COMMENT  = Cross platform audio library
LICENSE  =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static

include ../../mk/spksrc.cross-cc.mk

