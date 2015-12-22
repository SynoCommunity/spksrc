PKG_NAME = libtorrent
PKG_VERS = 0.13.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rakshasa/libtorrent/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/openssl cross/libsigc++

HOMEPAGE = https://rakshasa.github.io
COMMENT  = LibTorrent is a BitTorrent library written in C++ for *nix, with a focus on high performance and good code.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
PRE_PATCH_TARGET = myPrePatch
CONFIGURE_ARGS = --disable-instrumentation

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPrePatch
myPrePatch:
	@$(RUN) ./autogen.sh
