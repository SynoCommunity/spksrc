PKG_NAME = libarchive
PKG_VERS = 3.7.3

PKG_DIST_SITE = https://github.com/libarchive/$(PKG_NAME)/releases/download/v$(PKG_VERS)
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

COMMENT = Multi-format archive and compression library
HOMEPAGE = https://www.libarchive.org/
LICENSE = 3-Clause BSD

# why does it still use only system autoconf?!?
#BUILD_DEPENDS = cross/autoconf

# why does this still crash building synocli-file with pixz?!?
#BUILD_DEPENDS = cross/iconv
# or
#BUILD_DEPENDS = cross/libiconv
# above does nothing, must disable iconv below

DEPENDS = cross/openssl3

GNU_CONFIGURE = 1
CONFIGURE_ARGS += --without-iconv

include ../../mk/spksrc.cross-cc.mk
