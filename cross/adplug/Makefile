PKG_NAME = adplug
PKG_VERS = 2.2.1
PKG_EXT = tar.bz2
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_DIST_NAME = $(PKG_DIR).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/adplug/files/AdPlug%20core%20library/$(PKG_VERS)

DEPENDS = cross/libbinio

HOMEPAGE = http://adplug.github.io/
COMMENT  = Free, cross-platform, hardware independent AdLib sound player library, mainly written in C++. AdPlug plays sound data, originally created for the AdLib (OPL2) and Sound Blaster (Dual OPL2/OPL3) audio boards, directly from its original format on top of an emulator or by using the real hardware. No OPL chip is required for playback.
LICENSE  = LGPL

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --disable-static --enable-shared

include ../../mk/spksrc.cross-cc.mk

