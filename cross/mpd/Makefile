PKG_NAME = mpd
PKG_VERS = 0.23.15
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MusicPlayerDaemon/MPD/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = MPD-$(PKG_VERS)

# with mpd ver 0.22 (2020/09/23)
# - switch to C++17 (GCC 8 or clang 5)
# GCC version is too old. You need at least version 8.
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

include ../../mk/spksrc.archs.mk

DEPENDS  = cross/glib
DEPENDS += cross/alsa-lib
DEPENDS += cross/libmad
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
DEPENDS += cross/sqlite
DEPENDS += cross/libexpat
DEPENDS += cross/opus
DEPENDS += cross/pcre
DEPENDS += cross/libmpdclient

HOMEPAGE = https://www.musicpd.org/
COMMENT  = Music Player Daemon (MPD) is a flexible, powerful, server-side application for playing music.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

BOOST_LIBRARIES += system
ENV += BOOST_LIBRARIES="$(BOOST_LIBRARIES)"

include ../../mk/spksrc.archs.mk
ifeq ($(findstring $(ARCH),$(i686_ARCHS)),$(ARCH))  
# define value missing in socket.h in evansport toolchain
ADDITIONAL_CXXFLAGS = -DSO_REUSEPORT=15
endif

# If your boost headers or libraries are in non-standard locations you can set the BOOST_ROOT, 
# or the BOOST_INCLUDEDIR and BOOST_LIBRARYDIR environment variables. (added in 0.56.0) 
# You can also set these parameters as boost_root, boost_include, and boost_librarydir in your native 
# or cross machine file. 
# Note that machine file variables are preferred to environment variables, and that specifying 
# any of these disables system-wide search for boost.
ENV += BOOST_INCLUDEDIR=$(STAGING_INSTALL_PREFIX)/include/boost
ENV += BOOST_LIBRARYDIR=$(STAGING_INSTALL_PREFIX)/lib

include ../../mk/spksrc.cross-meson.mk
