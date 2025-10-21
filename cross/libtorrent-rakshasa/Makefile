PKG_NAME = libtorrent
PKG_VERS = 0.14.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rakshasa/rtorrent/releases/download/v0.10.0
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/openssl3 cross/libsigc++

# A compiler with support for C++14 language features is required.
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

HOMEPAGE = https://github.com/rakshasa/rtorrent/wiki
COMMENT  = LibTorrent is a BitTorrent library written in C++ for *nix, with a focus on high performance and good code.
LICENSE  = GPLv2

GNU_CONFIGURE = 1

CONFIGURE_ARGS = --disable-instrumentation
CONFIGURE_ARGS += --with-zlib=$(STAGING_INSTALL_PREFIX)

# disable some compiler warnings:
ADDITIONAL_CXXFLAGS = -Wno-deprecated-declarations -Wno-deprecated -Wno-terminate -Wno-sign-compare
ADDITIONAL_CFLAGS = -O2

include ../../mk/spksrc.cross-cc.mk
