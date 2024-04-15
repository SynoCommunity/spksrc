PKG_NAME = libarchive
PKG_VERS = 3.7.3

PKG_DIST_SITE = https://github.com/libarchive/libarchive/archive
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

COMMENT = Multi-format archive and compression library
HOMEPAGE = https://www.libarchive.org/
#LICENSE = https://github.com/libarchive/libarchive/blob/master/COPYING

BUILD_DEPENDS = cross/openssl3

PRE_CONFIGURE_TARGET = libarchive_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: libarchive_pre_configure
libarchive_pre_configure:
	$(RUN) build/autogen.sh
