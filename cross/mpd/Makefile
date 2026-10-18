PKG_NAME = mpd
PKG_VERS = 0.24.8
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/MusicPlayerDaemon/MPD/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = MPD-$(PKG_VERS)

HOMEPAGE = https://www.musicpd.org/
COMMENT  = Music Player Daemon (MPD) is a flexible, powerful, server-side application for playing music.
LICENSE  = GPLv2

# with mpd ver 0.24 (2025/03/11)
# - switch to C++20 (GCC 12 or clang 14)
# - removed Boost dependency
# meson only warns -- "Your GCC version is too old.  You need at least version
# 12." is a warning(), not an error() -- so the build runs on and dies in the
# compiler. Measured on dakota-1.3 (gcc 10.3.0, the newest gcc any SRM toolchain
# carries), ninja stops at 230 of 577 objects on two libstdc++ 12 features:
#   src/tag/Id3Load.cxx:55:   error: 'make_unique_for_overwrite' is not a member
#                             of 'std'                  (10 files use it)
#   src/input/Registry.cxx:30: error: class template argument deduction failed:
#                             'FilteredContainer{all.begin(), all.end(),
#                             input_plugins_enabled}'
# DSM 7.2 is the first DSM with gcc 12.2, which is what the DSM floor here used
# to stand for. Stating the compiler also refuses every SRM: 1.3 tops out at gcc
# 10.3 and 1.2 at 4.9.3, so no SRM toolchain can build 0.24 -- see spk/mpd.
MIN_GCC_VERSION = 12

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
DEPENDS += cross/sqlite
DEPENDS += cross/libexpat
DEPENDS += cross/opus
DEPENDS += cross/pcre
DEPENDS += cross/libmpdclient

include ../../mk/spksrc.cross-meson.mk
