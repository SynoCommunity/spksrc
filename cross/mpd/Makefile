PKG_NAME = mpd
PKG_VERS = 0.20.23
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MusicPlayerDaemon/MPD/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = MPD-$(PKG_VERS)

# A compiler with support for C++14 language features is required.
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(OLD_PPC_ARCHS)

include ../../mk/spksrc.archs.mk

DEPENDS  = cross/glib
DEPENDS += cross/alsa-lib
ifneq ($(findstring $(ARCH),comcerto2k),$(ARCH))
# comcerto2k fails with
# Error: selected processor does not support Thumb mode `rsc r3,r3,#0'
DEPENDS += cross/libmad
endif
DEPENDS += cross/libogg 
DEPENDS += cross/flac
DEPENDS += cross/audiofile
DEPENDS += cross/libid3tag
DEPENDS += cross/libvorbis
DEPENDS += cross/libtheora
DEPENDS += cross/lame
DEPENDS += cross/libshout
DEPENDS += cross/soxr
DEPENDS += cross/curl
DEPENDS += cross/boost

HOMEPAGE = https://www.musicpd.org/
COMMENT  = Music Player Daemon (MPD) is a flexible, powerful, server-side application for playing music.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = mpd_pre_configure

BOOST_LIBRARIES += system
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/spksrc.cross-cc.mk

.PHONY: mpd_pre_configure
mpd_pre_configure:
	$(RUN) ./autogen.sh
