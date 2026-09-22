PKG_NAME = libtorrent
PKG_VERS = 0.16.23
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rakshasa/rtorrent/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl3 cross/libsigc++ cross/curl

# libtorrent-rakshasa mandates C++20 (std::ranges needs GCC 10+):
# configure fails on GCC 8.5 and older (verified) and builds green
# on GCC 12.2
MIN_GCC_VERSION = 10

HOMEPAGE = https://github.com/rakshasa/rtorrent/wiki
COMMENT  = LibTorrent is a BitTorrent library written in C++ for *nix, with a focus on high performance and good code.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-instrumentation

# disable some compiler warnings:
ADDITIONAL_CXXFLAGS = -Wno-deprecated-declarations -Wno-deprecated -Wno-terminate -Wno-sign-compare
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
