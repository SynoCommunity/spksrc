PKG_NAME = advancecomp
PKG_VERS = 2.6
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/amadvance/advancecomp/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

HOMEPAGE = http://www.advancemame.it/
COMMENT  = A collection of recompression utilities for your .ZIP archives, .PNG snapshots, .MNG video clips and .GZ files.
LICENSE  = GPLv3

GNU_CONFIGURE = 1

include ../../mk/spksrc.cross-cc.mk
