PKG_NAME = jansson
PKG_VERS = 2.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.digip.org/$(PKG_NAME)/releases/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/harfbuzz/harfbuzz
COMMENT  = Jansson is a C library for encoding, decoding and manipulating JSON data
LICENSE  =


GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-shared=yes --with-pic

include ../../mk/spksrc.cross-cc.mk
