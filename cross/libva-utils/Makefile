PKG_NAME = libva-utils
PKG_VERS = 2.15.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/intel/libva-utils/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libva

HOMEPAGE = https://01.org/linuxmedia
COMMENT = Libva-utils is a collection of tests for VA-API (Video Acceleration API)
LICENSE = MIT

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

include ../../mk/spksrc.cross-meson.mk
