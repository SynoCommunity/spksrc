PKG_NAME = libarchive
PKG_VERS = 3.7.3

PKG_DIST_SITE = https://github.com/libarchive/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

COMMENT = Multi-format archive and compression library
HOMEPAGE = https://www.libarchive.org/
LICENSE = 3-Clause BSD

BUILD_DEPENDS = native/autoconf
DEPENDS = cross/openssl3

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --without-iconv

include ../../mk/spksrc.cross-cc.mk
