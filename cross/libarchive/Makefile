PKG_NAME = libarchive
PKG_VERS = 3.7.3
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/libarchive/libarchive/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

COMMENT = Multi-format archive and compression library
HOMEPAGE = https://www.libarchive.org/
LICENSE = 3-Clause BSD

DEPENDS = cross/openssl3

GNU_CONFIGURE = 1

# libiconv does not support pkgconfig file, therefore
# linking with libarchive in pixz does not find iconv dependency
CONFIGURE_ARGS = --without-iconv
CONFIGURE_ARGS += --disable-static
# disable tools, we want libarchive only
CONFIGURE_ARGS += --disable-bsdtar
CONFIGURE_ARGS += --disable-bsdcat
CONFIGURE_ARGS += --disable-bsdcpio
CONFIGURE_ARGS += --disable-bsdunzip

ADDITIONAL_CFLAGS = -O

include ../../mk/spksrc.cross-cc.mk
