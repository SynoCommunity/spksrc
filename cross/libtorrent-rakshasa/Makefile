PKG_NAME = libtorrent
PKG_VERS = 0.13.8
PKG_EXT = tar.gz
PKG_DIST_SITE = https://github.com/rakshasa/libtorrent/archive
#PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
#PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
#PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
PKG_GIT_HASH = 71a487c66b136524bce5519cb1f9e855621a9101
PKG_DIST_NAME = $(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_GIT_HASH)

DEPENDS = cross/cppunit cross/openssl3 cross/libsigc++ cross/zlib

HOMEPAGE = https://rakshasa.github.io
COMMENT  = LibTorrent is a BitTorrent library written in C++ for *nix, with a focus on high performance and good code.
LICENSE  = GPLv2

# requires C++14 support
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

GNU_CONFIGURE = 1
PRE_PATCH_TARGET = libtorrent_pre_patch
CONFIGURE_ARGS = --disable-instrumentation --with-zlib=$(STAGING_INSTALL_PREFIX)
ADDITIONAL_CXXFLAGS = -fno-strict-aliasing

include ../../mk/spksrc.cross-cc.mk

.PHONY: libtorrent_pre_patch
libtorrent_pre_patch:
	@$(RUN) autoreconf -fi
