PKG_NAME = libtorrent
PKG_VERS = 0.13.8
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rakshasa/libtorrent/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/cppunit cross/openssl cross/libsigc++ cross/zlib

HOMEPAGE = https://rakshasa.github.io
COMMENT  = LibTorrent is a BitTorrent library written in C++ for *nix, with a focus on high performance and good code.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_PATCH_TARGET = libtorrent_pre_patch
CONFIGURE_ARGS = --disable-instrumentation --with-zlib=$(STAGING_INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk

.PHONY: libtorrent_pre_patch
libtorrent_pre_patch:
	@$(RUN) ./autogen.sh
